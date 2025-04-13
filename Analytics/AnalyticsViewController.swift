//
//  AnalyticsViewController.swift
//  Analytics
//
//  Created by Глеб Хамин on 08.04.2025.
//

import UIKit
import UIComponents
import Core

public final class AnalyticsViewController: UIViewController {

    private var isProgrammaticScroll = false
    private var itemWidth = CGFloat(UIScreen.main.bounds.width)
    private var stringTimePeriod: String = "Февраль"
    private var arr: [Int] = [10, 11, 12, 13, 14, 15, 16]


    // MARK: - UI Components

    private lazy var buttonNewExpense: UIButton = {

        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 60 / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 7.3 / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .cAccent
        button.addTarget(self, action: #selector(didNewExpense), for: .touchUpInside)
        return button
    }()

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Анаталика"
        label.font = UIFont.h1
        label.textColor = .primaryText
        return label
    }()

    private lazy var titleStack: UIStackView = {

        let buttonCategory: UIButton = getButtonInNavigationBar(iconName: AppIcon.filter.rawValue)
        buttonCategory.addTarget(self, action: #selector(didCategory), for: .touchUpInside)

        let buttonSettings: UIButton = getButtonInNavigationBar(iconName: AppIcon.setting.rawValue)
        buttonSettings.addTarget(self, action: #selector(didSettings), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [labelTitle, buttonCategory, buttonSettings])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private lazy var timePeriod = UITimePeriodSegmentControl { period in
        self.didTapSegment(period: period)
    }

    private lazy var labelTimePeriod: UILabel = {
        let label = UILabel()
        label.text = stringTimePeriod
        label.font = UIFont.h3
        label.textColor = .secondaryText
        return label
    }()

    private lazy var analitycsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 0
        layout.itemSize = CGSize(width: itemWidth, height: 160)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CellAnalitycs.self)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true

        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = arr.count
        pageControl.currentPage = 2
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .cAccent
        pageControl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        return pageControl
    }()

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()



        navigationController?.isNavigationBarHidden = true
        setupLayout()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: 2, section: 0)
        analitycsCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

//    public init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    @objc private func didNewExpense() {
        print("Кнопка создания нового расхода нажата")
    }

    @objc private func didCategory() {
        print("Кнопка выбора категорий нажата")
    }

    @objc private func didSettings() {
        print("Кнопка настройки нажата")
    }

    @objc func pageControlChanged() {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        analitycsCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func didTapSegment(period: TimePeriod) {
        print(period.rawValue)
    }

    private func getButtonInNavigationBar(iconName: String) -> UIButton {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = .primaryBg
        button.setImage(UIImage(named: iconName), for: .normal)
        button.tintColor = .secondaryText
        return button
    }

}

extension AnalyticsViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arr.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellAnalitycs = collectionView.dequeueReusableCell(indexPath: indexPath)
        return cell
    }


}

extension AnalyticsViewController: UICollectionViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isProgrammaticScroll = false
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard !isProgrammaticScroll else { return }
//        let centerX = scrollView.contentOffset.x + scrollView.bounds.size.width / 2
//
//        let visibleCells = analitycsCollection.visibleCells
//        var closestDistance = CGFloat.greatestFiniteMagnitude
//
//        for cell in visibleCells {
//            let cellCenterX = cell.frame.origin.x + cell.frame.size.width / 2
//            let distance = abs(centerX - cellCenterX)
//
//            if distance < closestDistance {
//                closestDistance = distance
//            }
//        }

        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page

        if page == arr.count - 2 {
            addNewItem()
        } else if page == 1 {
            addNewFirstItem()
        }
    }

    private func addNewItem() {
        let newItem = arr.count + 1
        arr.append(newItem)

        let newIndexPath = IndexPath(item: arr.count - 1, section: 0)
        analitycsCollection.performBatchUpdates({
            analitycsCollection.insertItems(at: [newIndexPath])
        })
        pageControl.numberOfPages = arr.count
    }

    private func addNewFirstItem() {
        arr.insert(0, at: 0)
        let newIndexPath = IndexPath(item: 0, section: 0)
        analitycsCollection.performBatchUpdates({
            analitycsCollection.insertItems(at: [newIndexPath])
        })
        pageControl.numberOfPages = arr.count
        pageControl.currentPage = 2
    }
}

// MARK: Extension - Setu Layout

extension AnalyticsViewController {

    private func setupLayout() {
        view.backgroundColor = .secondaryBg
        view.setupView(buttonNewExpense)
        view.setupView(titleStack)
        view.setupView(timePeriod)
        view.setupView(labelTimePeriod)
        view.setupView(analitycsCollection)
        view.setupView(pageControl)

        NSLayoutConstraint.activate([
            buttonNewExpense.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonNewExpense.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 2),

            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            timePeriod.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 12),
            timePeriod.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timePeriod.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleStack.heightAnchor.constraint(equalToConstant: 40),

            labelTimePeriod.topAnchor.constraint(equalTo: timePeriod.bottomAnchor, constant: 20),
            labelTimePeriod.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelTimePeriod.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelTimePeriod.heightAnchor.constraint(equalToConstant: 20),

            analitycsCollection.topAnchor.constraint(equalTo: labelTimePeriod.bottomAnchor, constant: 20),
            analitycsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            analitycsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            analitycsCollection.heightAnchor.constraint(equalToConstant: 160),

            pageControl.topAnchor.constraint(equalTo: analitycsCollection.bottomAnchor, constant: 20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 100),

        ])
    }
}

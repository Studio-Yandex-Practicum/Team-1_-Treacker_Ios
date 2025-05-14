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

    // MARK: - Private Properties

    private var viewModel: AnalyticsViewModelProtocol
    private var itemWidth = CGFloat(UIScreen.main.bounds.width)

    // MARK: - UI Components: ButtonNewExpense

    private lazy var buttonNewExpense: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: UIConstants.Constants.large60.rawValue).isActive = true
        button.widthAnchor.constraint(equalToConstant: UIConstants.Constants.large60.rawValue).isActive = true
        button.setImage(UIImage(named: AppIcon.plus1.rawValue), for: .normal)
        button.tintColor = .whiteText
        button.layer.cornerRadius = UIConstants.Constants.large60.rawValue / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 7.3 / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .cAccent
        button.addTarget(self, action: #selector(didNewExpense), for: .touchUpInside)
        return button
    }()

    // MARK: - TitleStack

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.text = GlobalConstants.analyticsTitle.rawValue
        label.font = .h1Font
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
        stack.spacing = UIConstants.Spacing.small8.rawValue
        return stack
    }()

    // MARK: - SegmentControl

    private lazy var timePeriod = UITimePeriodSegmentControl { [weak self] period in
        self?.didTapSegment(period: period)
    }

    // MARK: - Analytics

    private lazy var labelTimePeriod: UILabel = {
        let label = UILabel()
        label.text = viewModel.titleTimePeriod
        label.font = .h3Font
        label.textColor = .secondaryText
        return label
    }()

    private lazy var analyticsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 0
        layout.itemSize = CGSize(width: itemWidth, height: UIConstants.Heights.height160.rawValue)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CellAnalytics.self)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .secondaryBg
        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = viewModel.pieChartDisplayItem.count
        pageControl.currentPage = viewModel.selectedIndex
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .cAccent
        pageControl.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height24.rawValue).isActive = true
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        return pageControl
    }()

    // MARK: - TitleExpenses

    private lazy var labelCategory: UILabel = {
        let label = UILabel()
        label.text = GlobalConstants.analyticsTitleExpense.rawValue
        label.font = .h4Font
        label.textColor = .secondaryText
        return label
    }()

    private lazy var buttonSorted: UIButton = {
        let button: UIButton = getButtonInNavigationBar(iconName: AppIcon.sort.rawValue)
        button.addTarget(self, action: #selector(didSort), for: .touchUpInside)
        button.tintColor = .primaryText
        return button
    }()

    private lazy var categoryStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [labelCategory, buttonSorted])
        stack.axis = .horizontal
        return stack
    }()

    // MARK: - TableExpenses

    private lazy var tableExpenses: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .secondaryBg
        table.register(CellCategoryExpense.self)
        table.delegate = self
        table.dataSource = self
        return table
    }()

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        viewModel.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupLayout()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: viewModel.selectedIndex, section: 0)
        analyticsCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        pageControl.currentPage = viewModel.currentIndex
    }

    // MARK: - Initializers

    public init(viewModel: AnalyticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bind

    private func bind() {
        viewModel.onSelectedIndex = { [weak self] index in
            let indexPath = IndexPath(item: index, section: 0)
            self?.analyticsCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            self?.pageControl.currentPage = index
            self?.tableExpenses.reloadData()
        }
        viewModel.onModelCellCategory = { [weak self] in
            self?.tableExpenses.reloadData()
        }
        viewModel.onPieChartDisplayItem = { [weak self] count in
            self?.analyticsCollection.reloadData()
            self?.pageControl.numberOfPages = count
        }
        viewModel.onTitleTimePeriod = { [weak self] title in
            self?.labelTimePeriod.text = title
        }
        viewModel.onTypeTimePeriod = { [weak self] type in
            switch type {
            case .day, .week, .month, .year:
                self?.pageControl.isHidden = false
                self?.timePeriod.updateSelectedTimePeriod(to: type)
            case .custom:
                self?.pageControl.isHidden = true
            }
        }
    }

    // MARK: - Actions

    @objc private func didNewExpense() {
        viewModel.didTapOpenNewExpense()
    }

    @objc private func didCategory() {
        viewModel.didTapOpenCategorySelection()
    }

    @objc private func didSettings() {
        viewModel.didTapOpenSetting()
    }

    @objc private func didSort() {
        viewModel.updateCategorySortOrder()
    }

    @objc private func pageControlChanged() {
        viewModel.updateSelectedIndex(pageControl.currentPage)
    }

    // MARK: - Private Methods

    private func didTapSegment(period: TimePeriod) {
        viewModel.updateTypeTimePeriod(period)
    }

    private func getButtonInNavigationBar(iconName: String) -> UIButton {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: UIConstants.Constants.large40.rawValue).isActive = true
        button.widthAnchor.constraint(equalToConstant: UIConstants.Constants.large40.rawValue).isActive = true
        button.layer.cornerRadius = UIConstants.CornerRadius.small12.rawValue
        button.layer.masksToBounds = true
        button.backgroundColor = .primaryBg
        button.setImage(UIImage(named: iconName), for: .normal)
        button.tintColor = .secondaryText
        return button
    }

}

// MARK: - Extension: UICollectionViewDataSource

extension AnalyticsViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pieChartDisplayItem.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellAnalytics = collectionView.dequeueReusableCell(indexPath: indexPath)
        let segment = viewModel.pieChartDisplayItem[indexPath.item]
        cell.configureCell(amount: segment.amount, segments: segment.segments)
        return cell
    }

}

// MARK: - Extension: UICollectionViewDelegate

extension AnalyticsViewController: UICollectionViewDelegate {

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === analyticsCollection else { return }

        let width = scrollView.frame.width
        let offset = scrollView.contentOffset.x

        guard width > 0 else { return }
        let page = Int(offset / width)

        viewModel.updateSelectedIndex(page)
    }

}

extension AnalyticsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.modelCellCategory.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellCategoryExpense = tableView.dequeueReusableCell()
        let model: ModelCellCategory = viewModel.modelCellCategory[indexPath.row]
        cell.configureCell(category: model)
        return cell
    }

}

extension AnalyticsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapOpenCategoryExpenses(index: indexPath.row)
    }
}

// MARK: Extension - Setu Layout

extension AnalyticsViewController {

    private func setupLayout() {
        view.backgroundColor = .secondaryBg
        view.setupView(titleStack)
        view.setupView(timePeriod)
        view.setupView(labelTimePeriod)
        view.setupView(analyticsCollection)
        view.setupView(pageControl)
        view.setupView(categoryStack)
        view.setupView(tableExpenses)
        view.setupView(buttonNewExpense)

        NSLayoutConstraint.activate([
            buttonNewExpense.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            buttonNewExpense.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.Constants.small2.rawValue),

            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.Constants.large20.rawValue),
            titleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            titleStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),

            timePeriod.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: UIConstants.Constants.medium12.rawValue),
            timePeriod.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            timePeriod.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            titleStack.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height40.rawValue),

            labelTimePeriod.topAnchor.constraint(equalTo: timePeriod.bottomAnchor, constant: UIConstants.Constants.large20.rawValue),
            labelTimePeriod.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            labelTimePeriod.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),
            labelTimePeriod.heightAnchor.constraint(equalToConstant: UIConstants.Constants.large20.rawValue),

            analyticsCollection.topAnchor.constraint(equalTo: labelTimePeriod.bottomAnchor, constant: UIConstants.Constants.large20.rawValue),
            analyticsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            analyticsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            analyticsCollection.heightAnchor.constraint(equalToConstant: UIConstants.Heights.height160.rawValue),

            pageControl.topAnchor.constraint(equalTo: analyticsCollection.bottomAnchor, constant: UIConstants.Constants.large20.rawValue),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: UIConstants.Widths.width100.rawValue),

            categoryStack.topAnchor.constraint(equalTo: analyticsCollection.bottomAnchor, constant: UIConstants.Constants.large55.rawValue),
            categoryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.Constants.large20.rawValue),
            categoryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.Constants.large20.rawValue),

            tableExpenses.topAnchor.constraint(equalTo: categoryStack.bottomAnchor, constant: UIConstants.Constants.small8.rawValue),
            tableExpenses.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableExpenses.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableExpenses.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

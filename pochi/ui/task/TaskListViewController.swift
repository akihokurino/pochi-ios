//
//  TaskListViewController.swift
//  pochi
//
//  Created by akiho on 2017/05/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: TaskListDataSource!
    private let viewModel: TaskListViewModel = TaskListViewModel()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var dialogDelegate: DialogDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupDialog()
        setupTableView()
        observeTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView?.isHidden = false
        tableView.backgroundView?.isHidden = true
        viewModel.fetchAll()
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupDialog() {
        self.dialogDelegate = DialogDelegate(container: self)
    }
    
    private func setupTableView() {
        dataSource = TaskListDataSource(tableView: tableView)
        let emptyView = EmptyView.instance()
        emptyView.bind(data: EmptyView.DisplayData(message: "タスクはありません"))
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.tableFooterView = FooterLoadingView.instance()
    }
    
    func refresh() {
        viewModel.refresh()
    }
    
    private func observeTableView() {
        tableView.rx.modelSelected(UserTask.self)
            .asDriver()
            .filter({ task -> Bool in
                let currentTime: Int64 = DateDelegate.dateToTimestamp(date: Date())
                let taskDate: Date = DateDelegate.stringToDate(dateString: task.date)!
                let taskTime: Int64 = DateDelegate.dateToTimestamp(date: taskDate)
                if currentTime < taskTime {
                    self.dialogDelegate.simpleAlert(title: "このタスクはまだ実行できません")
                    return false
                } else {
                    return true
                }
            })
            .drive(onNext: { task in
                self.viewModel.selectedTask = task
                switch task.type {
                case .review:
                    self.performSegue(withIdentifier: R.segue.taskListViewController.fromTaskListToReviewTask, sender: nil)
                case .report:
                    self.performSegue(withIdentifier: R.segue.taskListViewController.fromTaskListToReportTask, sender: nil)
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeTasks.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        viewModel.observeEvent
            .drive(onNext: { event in
                switch event {
                case .none:
                    break
                case .refreshed:
                    self.refreshControl.endRefreshing()
                    self.tableView.tableFooterView?.isHidden = false
                case .empty:
                    self.tableView.backgroundView?.isHidden = false
                case .completedTaskPagination:
                    self.tableView.tableFooterView?.isHidden = true
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.taskListViewController.fromTaskListToReviewTask.identifier && viewModel.selectedTask != nil {
            let to = segue.destination as! ReviewTaskViewController
            to.bind(task: self.viewModel.selectedTask!)
        } else if segue.identifier == R.segue.taskListViewController.fromTaskListToReportTask.identifier && viewModel.selectedTask != nil {
            let to = segue.destination as! ReportTaskViewController
            to.bind(task: self.viewModel.selectedTask!)
        }
    }
}

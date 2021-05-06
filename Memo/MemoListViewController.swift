//
//  ViewController.swift
//  Memo
//
//  Created by jylee-mac on 2021/05/05.
//

import UIKit

class MemoListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var isTodayButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    let memoListViewModel = MemoViewModel()
    
    // TODO: TodoViewModel 만들기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // TODO: 데이터 불러오기
        memoListViewModel.loadTasks()
    }
    
    @IBAction func isTodayButtonTapped(_ sender: Any) {
        // TODO: 투데이 버튼 토글 작업
        isTodayButton.isSelected = !isTodayButton.isSelected
    }
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        // TODO: Todo 태스크 추가
        // add task to view model
        // and tableview reload or update
        
        guard let detail = inputTextField.text, detail.isEmpty == false else {
            return
        }
        
        let memo = MemoManager.shared.createMemo(detail: detail, isToday: isTodayButton.isSelected)
        memoListViewModel.addMemoe(memo)
        collectionView.reloadData()
        inputTextField.text = ""
        isTodayButton.isSelected = false
        
    }
    
    @IBAction func tapBackground(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
    // TODO: BG 탭했을때, 키보드 내려오게 하기
}

extension MemoListViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // [x] TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
    }
}

extension MemoListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: 섹션 몇개
        return memoListViewModel.numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: 섹션별 아이템 몇개
        if section == 0 {
            return memoListViewModel.todayMemoes.count
        }else{
            return memoListViewModel.upcompingMemoes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: 커스텀 셀
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoListCell", for: indexPath) as? MemoListCell else {
            return UICollectionViewCell()
        }
        
        var memo : Memo
        if indexPath.section == 0 {
            memo = memoListViewModel.todayMemoes[indexPath.item]
        }else{
            memo = memoListViewModel.upcompingMemoes[indexPath.item]
        }
        cell.updateUI(memo: memo)
        
        // TODO: todo 를 이용해서 updateUI
        // TODO: doneButtonHandler 작성
        // TODO: deleteButtonHandler 작성
        
        cell.doneButtonTapHandler = { isDone in
            memo.isDone = isDone
            self.memoListViewModel.updateMemo(memo)
            self.collectionView.reloadData()
        }
        
        cell.deleteButtonTapHandler = {
            self.memoListViewModel.deleteMemo(memo)
            self.collectionView.reloadData()
        }
        
        return cell
        
        
     //   return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MemoListHeaderView", for: indexPath) as? MemoListHeaderView else {
                return UICollectionReusableView()
            }
            
            guard let section = MemoViewModel.Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            
            header.sectionTitleLabel.text = section.title
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension MemoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: 사이즈 계산하기
        
        let width : CGFloat = collectionView.bounds.width
        let height : CGFloat = 50
        
        
        return CGSize(width: width, height: height)
    }
}

class MemoListCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var strikeThroughView: UIView!
    
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(memo: Memo) {
        // TODO: 셀 업데이트 하기
        checkButton.isSelected = memo.isDone
        descriptionLabel.text = memo.detail
        descriptionLabel.alpha = memo.isDone ? 0.2 : 1
        deleteButton.isHidden = memo.isDone == false
        showStrikeThrough(memo.isDone)
    }
    
    private func showStrikeThrough(_ show: Bool) {
        if show {
            strikeThroughWidth.constant = descriptionLabel.bounds.width
        } else {
            strikeThroughWidth.constant = 0
        }
    }
    
    func reset() {
        // TODO: reset로직 구현
        descriptionLabel.alpha = 1
        deleteButton.isHidden = true
        showStrikeThrough(false)
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        // TODO: checkButton 처리
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(isDone)
        descriptionLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone
        doneButtonTapHandler?(isDone)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        // TODO: deleteButton 처리
        deleteButtonTapHandler?()
    }
}

class MemoListHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

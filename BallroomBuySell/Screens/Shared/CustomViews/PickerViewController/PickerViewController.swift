//
//  PickerViewController.swift
//  BallroomBuySell
//
//  Created by Taylor Chapman on 2022-01-06.
//  Adapted from Lawrence Tran
//

import UIKit

typealias PickerDelegate = CustomPickerViewDelegate & UIPickerViewDelegate

protocol CustomPickerViewDelegate {
    // Picker methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    func startingSelectedIndexForComponent(component: Int) -> Int
    func pickerView(picker: UIPickerView, clickDoneForDataSource: PickerDelegate)
    func pickerView(controller: PickerViewController, didCancelForDataSource: PickerDelegate)
    
    // Date picker methods
    func setupDatePicker() -> (startingDate: Date?, maximumDate: Date?, minimumDate: Date?, mode: UIDatePicker.Mode)?
    func pickerViewClickDoneFor(datePicker: UIDatePicker)
}

class PickerViewController: UIViewController, UIPickerViewDataSource {
    enum PickerViewType {
        case picker, datePicker
    }
    
    @IBOutlet weak var pickerBackgroundView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var actionContainerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerContainerBottom: NSLayoutConstraint!

    private let pickerContainerHeight: CGFloat = 260
    private var pickerDataSource: PickerDelegate?
    private var owner: UIViewController?
    private var delegate: PickerDelegate?
    private var pickerType: PickerViewType?
    
    static func createViewController(delegate: PickerDelegate?,
                                     pickerType: PickerViewType = .picker,
                                     owner: UIViewController?) -> PickerViewController {
        let pickerViewController = PickerViewController(nibName: String(describing: PickerViewController.self), bundle: nil)
        pickerViewController.owner = owner
        pickerViewController.delegate = delegate
        pickerViewController.pickerType = pickerType
        return pickerViewController
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavigationController.hideNavigationBar(owner)
        
        pickerView.isHidden = pickerType != .picker
        datePicker.isHidden = pickerType != .datePicker
        
        pickerContainerBottom.constant = -pickerContainerHeight
        setupAccessibilityId()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NavigationController.showNavigationBar(owner)
    }
    
    // MARK: - IBAction
    @IBAction func CancelClicked() {
        guard let pickerDataSource = pickerDataSource else {
            return
        }
        
        dismissWith {
            self.delegate?.pickerView(controller: self, didCancelForDataSource: pickerDataSource)
        }
    }
    
    @IBAction func DoneClicked() {
        guard let pickerDataSource = pickerDataSource else {
            return
        }
        
        dismissWith {
            if self.pickerType == .picker {
                self.delegate?.pickerView(picker: self.pickerView, clickDoneForDataSource: pickerDataSource)
            } else {
                self.delegate?.pickerViewClickDoneFor(datePicker: self.datePicker)
            }
        }
    }
    
    // MARK: - UIPickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        delegate?.numberOfComponents(in: pickerView) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        delegate?.pickerView(pickerView, numberOfRowsInComponent: component) ?? 0
    }
    
    // MARK: - Public Methods
    func presentLayerIn(viewController: UIViewController, withDataSource dataSource: PickerDelegate) {
        viewController.addChild(self)
        viewController.view.addSubview(view)
        didMove(toParent: viewController)
        viewController.view.bringSubviewToFront(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let viewMap: [String: UIView] = ["view": view]
        viewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: [NSLayoutConstraint.FormatOptions(rawValue: 0)], metrics: nil, views: viewMap))
        viewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [NSLayoutConstraint.FormatOptions(rawValue: 0)], metrics: nil, views: viewMap))
        self.view.layoutIfNeeded()
        
        pickerDataSource = dataSource
        
        if pickerType == .picker {
            pickerView.dataSource = self
            pickerView.delegate = dataSource
            setupStartingValue()
        } else {
            setupDatePicker()
        }
        
        animatePicker(up: true)
    }
    
    // MARK: - Private Methods
    /// Calls the picker datasource to get starting index of each component
    private func setupStartingValue() {
        guard let componentCount = pickerDataSource?.numberOfComponents(in: pickerView) else {
            return
        }
        
        for component in 0 ..< componentCount {
            guard let index = pickerDataSource?.startingSelectedIndexForComponent(component: component) else {
                continue
            }
            
            pickerView.selectRow(index, inComponent: component, animated: false)
        }
    }
    
    private func setupDatePicker() {
        guard let dateData = pickerDataSource?.setupDatePicker() else {
            let defaultDate = getDefaultDatePickerDates()
            datePicker.minimumDate = defaultDate.minimumDate
            datePicker.maximumDate = defaultDate.maximumDate
            datePicker.setDate(Date(), animated: false)
            datePicker.datePickerMode = .date
            
            applyDatePickerTheme()
            return
        }
        
        let defaultDate = getDefaultDatePickerDates()
        datePicker.minimumDate = dateData.minimumDate ?? defaultDate.minimumDate
        datePicker.maximumDate = dateData.maximumDate ?? defaultDate.maximumDate
        datePicker.setDate(dateData.startingDate ?? Date(), animated: false)
        datePicker.datePickerMode = dateData.mode
        
        applyDatePickerTheme()
    }
    
    private func getDefaultDatePickerDates() -> (maximumDate: Date, minimumDate: Date) {
        (Calendar.current.date(byAdding: .year, value: 10, to: Date()) ?? Date(), Date(timeIntervalSince1970: 0))
    }
    
    private func dismissWith(_ completionHandler: @escaping () -> Void) {
        animatePicker(up: false, completionHandler: completionHandler)
    }
    
    /// Animates the picker either up or down and then runs the completion block thats passed in
    ///
    /// - Parameters:
    ///   - up: Animates the picker container view up or down
    ///   - completionHandler: Completion block to be run after animation
    private func animatePicker(up: Bool, completionHandler: (() -> Void)? = nil) {
        pickerContainerBottom.constant = up ? 0 : -pickerContainerHeight
        pickerBackgroundView.alpha = up ? 0.7 : 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            guard let completionHandler = completionHandler else {
                return
            }
            
            self.view.removeFromSuperview()
            self.removeFromParent()
            completionHandler()
        }
    }
    
    private func applyDatePickerTheme() {
        if #available(iOS 14.0, *) { // use old date picker style even when running iOS 14
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        //datePicker.backgroundColor = ThemeManager.sharedInstance.theme.backgroundColor // set background color here instead of IB because date picker resets background to white on setup
    }
    
    private func setupAccessibilityId() {
        doneButton.accessibilityIdentifier = "DoneBtn"
        cancelButton.accessibilityIdentifier = "CancelBtn"
        pickerView.accessibilityIdentifier = "Picker"
        datePicker.accessibilityIdentifier = "DatePicker"
    }
}

//
//  TwitterProfileViewController.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import UIKit
import SnapKit

 public class TwitterProfileViewController: CustomTransitionViewController {
  
  // Global tint
    public static var globalTint: UIColor = UIColor(red: 42.0/255.0, green: 163.0/255.0, blue: 239.0/255.0, alpha: 1)
  
  
  // Constants
    public let stickyheaderContainerViewHeight: CGFloat = 125
  
    public let bouncingThreshold: CGFloat = 100
  
    public let scrollToScaleDownProfileIconDistance: CGFloat = 60
  
   public var profileHeaderViewHeight: CGFloat = 160 {
    didSet {
      //self.view.setNeedsLayout()
      //self.view.layoutIfNeeded()
    }
  }
  
    public let segmentedControlContainerHeight: CGFloat = 46
  
   public var username: String? {
    didSet {
      self.profileHeaderView?.titleLabel?.text = username
      self.navigationTitleLabel?.text = username
    }
  }
  
   public var profileImage: UIImage? {
    didSet {
      self.profileHeaderView?.iconImageView?.image = profileImage
    }
  }
  
   public var locationString: String? {
    didSet {
      self.profileHeaderView?.locationLabel?.text = locationString
    }
  }
  
   public var descriptionString: String? {
    didSet {
      self.profileHeaderView?.descriptionLabel?.text = descriptionString
    }
  }
  
   public var coverImage: UIImage? {
    didSet {
      self.headerCoverView?.image = coverImage
    }
  }
  
  // Properties
  
  var currentIndex: Int = 0 {
    didSet {
      self.updateTableViewContent()
    }
  }
  
  var scrollViews: [UIScrollView] = []
  
  var currentScrollView: UIScrollView {
    return scrollViews[currentIndex]
  }
  
  
  fileprivate var mainScrollView: UIScrollView!
  
  var headerCoverView: UIImageView!
  
  var profileHeaderView: TwitterProfileHeaderView!
  
  var stickyHeaderContainerView: UIView!
  
  var blurEffectView: UIVisualEffectView!
  
  var segmentedControl: UISegmentedControl!
  
  var segmentedControlContainer: UIView!
  
  var navigationTitleLabel: UILabel!
  var navigationDetailLabel: UILabel!
  
  var debugTextView: UILabel!
  
  var shouldUpdateScrollViewContentFrame = false
  
  deinit {
    self.scrollViews.forEach { (scrollView) in
      scrollView.removeFromSuperview()
    }
    self.scrollViews.removeAll()
    
    print("[TwitterProfileViewController] memeory leak check passed")
  }

  override  public func viewDidLoad() {
    super.viewDidLoad()
    
    self.prepareForLayout()
    
    setNeedsStatusBarAppearanceUpdate()
    
    self.prepareViews()
    
    shouldUpdateScrollViewContentFrame = true
  }
  
  override  public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    print(profileHeaderView.sizeThatFits(self.mainScrollView.bounds.size))
    self.profileHeaderViewHeight = profileHeaderView.sizeThatFits(self.mainScrollView.bounds.size).height
    
    if self.shouldUpdateScrollViewContentFrame {
      
      // configure layout frames
      self.stickyHeaderContainerView.frame = self.computeStickyHeaderContainerViewFrame()
      
      self.profileHeaderView.frame = self.computeProfileHeaderViewFrame()
      
      self.segmentedControlContainer.frame = self.computeSegmentedControlContainerFrame()
      
      self.scrollViews.forEach({ (scrollView) in
        scrollView.frame = self.computeTableViewFrame(tableView: scrollView)
      })
      
      self.updateMainScrollViewFrame()
      
      self.mainScrollView.scrollIndicatorInsets = computeMainScrollViewIndicatorInsets()
      
      
      self.shouldUpdateScrollViewContentFrame = false
        self.mainScrollView.scrollsToTop = false
    }
  }

  override  public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
}

extension TwitterProfileViewController {
  
  func prepareViews() {
    let _mainScrollView = TouchRespondScrollView(frame: self.view.bounds)
    _mainScrollView.delegate = self
    _mainScrollView.showsHorizontalScrollIndicator = false
    
    self.mainScrollView  = _mainScrollView
    
    self.view.addSubview(_mainScrollView)
    
    _mainScrollView.snp.makeConstraints { (make) in
      make.edges.equalTo(self.view)
    }
    
    // sticker header Container view
    let _stickyHeaderContainer = UIView()
    _stickyHeaderContainer.clipsToBounds = true
    _mainScrollView.addSubview(_stickyHeaderContainer)
    self.stickyHeaderContainerView = _stickyHeaderContainer
    
    // Cover Image View
    let coverImageView = UIImageView()
    coverImageView.clipsToBounds = true
    _stickyHeaderContainer.addSubview(coverImageView)
    coverImageView.snp.makeConstraints { (make) in
      make.edges.equalTo(_stickyHeaderContainer)
    }
    
    coverImageView.image = UIImage(named: "background.png")
    coverImageView.contentMode = .scaleAspectFill
    coverImageView.clipsToBounds = true
    self.headerCoverView = coverImageView
    
    // blur effect on top of coverImageView
    let blurEffect = UIBlurEffect(style: .dark)
    let _blurEffectView = UIVisualEffectView(effect: blurEffect)
    _blurEffectView.alpha = 0
    self.blurEffectView = _blurEffectView
    
    _stickyHeaderContainer.addSubview(_blurEffectView)
    _blurEffectView.snp.makeConstraints { (make) in
      make.edges.equalTo(_stickyHeaderContainer)
    }
    
    // Detail Title
    let _navigationDetailLabel = UILabel()
    _navigationDetailLabel.text = "121 Tweets"
    _navigationDetailLabel.textColor = UIColor.white
    _navigationDetailLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
    _stickyHeaderContainer.addSubview(_navigationDetailLabel)
    _navigationDetailLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(_stickyHeaderContainer.snp.centerX)
      make.bottom.equalTo(_stickyHeaderContainer.snp.bottom).inset(8)
    }
    self.navigationDetailLabel = _navigationDetailLabel
    
    // Navigation Title
    let _navigationTitleLabel = UILabel()
    _navigationTitleLabel.text = self.username ?? "{username}"
    _navigationTitleLabel.textColor = UIColor.white
    _navigationTitleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
    _stickyHeaderContainer.addSubview(_navigationTitleLabel)
    _navigationTitleLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(_stickyHeaderContainer.snp.centerX)
      make.bottom.equalTo(_navigationDetailLabel.snp.top).offset(4)
    }
    self.navigationTitleLabel = _navigationTitleLabel
    
    // preset the navigation title and detail at progress=0 position
    animateNaivationTitleAt(progress: 0)
    
    // ProfileHeaderView
    
    if let _profileHeaderView = Bundle.main.loadNibNamed("TwitterProfileHeaderView", owner: self, options: nil)?.first as? TwitterProfileHeaderView {
      _mainScrollView.addSubview(_profileHeaderView)
      self.profileHeaderView = _profileHeaderView
      self.profileHeaderView.delegate = self
      
      self.profileHeaderView.usernameLabel.text = self.username
      self.profileHeaderView.locationLabel.text = self.locationString
      self.profileHeaderView.iconImageView.image = self.profileImage
      self.profileHeaderView.descriptionLabel.text = String(Authentication.shared.profile?.totalPoints ?? 0.0) + " Points"
//        self.profileHeaderView.usernameLabel.text = "@" + (Authentication.shared.profile?.emailId ?? "")
    }
    
    
    // Segmented Control Container
    let _segmentedControlContainer = UIView.init(frame: CGRect.init(x: 0, y: 0, width: mainScrollView.bounds.width, height: 100))
    _segmentedControlContainer.backgroundColor = UIColor.white
    _mainScrollView.addSubview(_segmentedControlContainer)
    self.segmentedControlContainer = _segmentedControlContainer
    
    // Segmented Control
    let _segmentedControl = UISegmentedControl()
    _segmentedControl.addTarget(self, action: #selector(self.segmentedControlValueDidChange(sender:)), for: .valueChanged)
    _segmentedControl.backgroundColor = UIColor.white

    for index in 0..<numberOfSegments() {
      let segmentTitle = self.segmentTitle(forSegment: index)
      _segmentedControl.insertSegment(withTitle: segmentTitle, at: index, animated: false)
    }
    _segmentedControl.selectedSegmentIndex = 0
    _segmentedControlContainer.addSubview(_segmentedControl)

    self.segmentedControl = _segmentedControl
    
    _segmentedControl.snp.makeConstraints { (make) in
      make.edges.equalTo(_segmentedControlContainer).inset(UIEdgeInsets.init(top: 8, left: 16, bottom: 8, right: 16))
      make.width.equalToSuperview().offset(-16)
      make.centerX.equalToSuperview()
      make.centerY.equalTo(_segmentedControlContainer.snp.centerY)
    }
    
    self.scrollViews = []
    for index in 0..<numberOfSegments() {
      let scrollView = self.scrollView(forSegment: index)
      self.scrollViews.append(scrollView)
      scrollView.isHidden = (index > 0)
      _mainScrollView.addSubview(scrollView)
    }
    
    self.showDebugInfo()
  }
  
  func computeStickyHeaderContainerViewFrame() -> CGRect {
    return CGRect(x: 0, y: 0, width: mainScrollView.bounds.width, height: stickyheaderContainerViewHeight)
  }
  
  func computeProfileHeaderViewFrame() -> CGRect {
    return CGRect(x: 0, y: computeStickyHeaderContainerViewFrame().origin.y + stickyheaderContainerViewHeight, width: mainScrollView.bounds.width, height: profileHeaderViewHeight)
  }
  
  func computeTableViewFrame(tableView: UIScrollView) -> CGRect {
    let upperViewFrame = computeSegmentedControlContainerFrame()
    return CGRect(x: 0, y: upperViewFrame.origin.y + upperViewFrame.height , width: mainScrollView.bounds.width, height: tableView.contentSize.height)
  }
  
  func computeMainScrollViewIndicatorInsets() -> UIEdgeInsets {
    return UIEdgeInsets.init(top: self.computeSegmentedControlContainerFrame().lf_originBottom, left: 0, bottom: 0, right: 0)
  }
  
  func computeNavigationFrame() -> CGRect {
    return headerCoverView.convert(headerCoverView.bounds, to: self.view)
  }
  
  func computeSegmentedControlContainerFrame() -> CGRect {
    let rect = computeProfileHeaderViewFrame()
    return CGRect(x: 0, y: rect.origin.y + rect.height, width: mainScrollView.bounds.width, height: segmentedControlContainerHeight)
    
  }
  
  func updateMainScrollViewFrame() {
    
    let bottomHeight = max(currentScrollView.bounds.height, 800)
    
    self.mainScrollView.contentSize = CGSize(
      width: view.bounds.width,
      height: stickyheaderContainerViewHeight + profileHeaderViewHeight + segmentedControlContainer.bounds.height + bottomHeight)
  }
}

extension TwitterProfileViewController: UIScrollViewDelegate {
   public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let contentOffset = scrollView.contentOffset
    self.debugContentOffset(contentOffset: contentOffset)
    
    // sticky headerCover
    if contentOffset.y <= 0 {
      let bounceProgress = min(1, abs(contentOffset.y) / bouncingThreshold)
      
      let newHeight = abs(contentOffset.y) + self.stickyheaderContainerViewHeight
      
      // adjust stickyHeader frame
      self.stickyHeaderContainerView.frame = CGRect(
        x: 0,
        y: contentOffset.y,
        width: mainScrollView.bounds.width,
        height: newHeight)
      
      // blurring effect amplitude
      self.blurEffectView.alpha = min(1, bounceProgress * 2)
      
      // scaling effect
      let scalingFactor = 1 + min(log(bounceProgress + 1), 2)
//      print(scalingFactor)
      self.headerCoverView.transform = CGAffineTransform(scaleX: scalingFactor, y: scalingFactor)
      
      // adjust mainScrollView indicator insets
      var baseInset = computeMainScrollViewIndicatorInsets()
      baseInset.top += abs(contentOffset.y)
      self.mainScrollView.scrollIndicatorInsets = baseInset
      
      self.mainScrollView.bringSubviewToFront(self.profileHeaderView)
    } else {
      
      // anything to be set if contentOffset.y is positive
      self.blurEffectView.alpha = 0
      self.mainScrollView.scrollIndicatorInsets = computeMainScrollViewIndicatorInsets()
    }
    
    // Universal
    // applied to every contentOffset.y
    let scaleProgress = max(0, min(1, contentOffset.y / self.scrollToScaleDownProfileIconDistance))
    self.profileHeaderView.animator(t: scaleProgress)
    
    if contentOffset.y > 0 {
    
      // When scroll View reached the threshold
      if contentOffset.y >= scrollToScaleDownProfileIconDistance {
        self.stickyHeaderContainerView.frame = CGRect(x: 0, y: contentOffset.y - scrollToScaleDownProfileIconDistance, width: mainScrollView.bounds.width, height: stickyheaderContainerViewHeight)
        
        // bring stickyHeader to the front
        self.mainScrollView.bringSubviewToFront(self.stickyHeaderContainerView)
      } else {
        self.mainScrollView.bringSubviewToFront(self.profileHeaderView)
        self.stickyHeaderContainerView.frame = computeStickyHeaderContainerViewFrame()
      }
      
      // Sticky Segmented Control
      let navigationLocation = CGRect(x: 0, y: 0, width: stickyHeaderContainerView.bounds.width, height: stickyHeaderContainerView.frame.origin.y - contentOffset.y + stickyHeaderContainerView.bounds.height)
      let navigationHeight = navigationLocation.height - abs(navigationLocation.origin.y)
      let segmentedControlContainerLocationY = stickyheaderContainerViewHeight + profileHeaderViewHeight - navigationHeight
      
      if contentOffset.y > 0 && contentOffset.y >= segmentedControlContainerLocationY {
  //    if segmentedControlLocation.origin.y <= navigationHeight {
        segmentedControlContainer.frame = CGRect(x: 0, y: contentOffset.y + navigationHeight, width: segmentedControlContainer.bounds.width, height: segmentedControlContainer.bounds.height)
      } else {
        segmentedControlContainer.frame = computeSegmentedControlContainerFrame()
      }
      
      // Override
      // When scroll View reached the top edge of Title label
      if let titleLabel = profileHeaderView.titleLabel, let usernameLabel = profileHeaderView.usernameLabel  {
        
        // titleLabel location relative to self.view
        let titleLabelLocationY = stickyheaderContainerViewHeight - 35
        
        let totalHeight = titleLabel.bounds.height + usernameLabel.bounds.height + 35
        let detailProgress = max(0, min((contentOffset.y - titleLabelLocationY) / totalHeight, 1))
        blurEffectView.alpha = detailProgress
        animateNaivationTitleAt(progress: detailProgress)
      }
    }
    // Segmented control is always on top in any situations
    self.mainScrollView.bringSubviewToFront(segmentedControlContainer)
  }
}

// MARK: Animators
extension TwitterProfileViewController {
  func animateNaivationTitleAt(progress: CGFloat) {
    
    guard let superview = self.navigationDetailLabel?.superview else {
      return
    }
    
    let totalDistance: CGFloat = 75
    
    if progress >= 0 {
      let distance = (1 - progress) * totalDistance
      self.navigationDetailLabel.snp.updateConstraints({ (make) in
        make.bottom.equalTo(superview.snp.bottom).inset(8 - distance)
      })
    }
  }
}

// status bar style override
extension TwitterProfileViewController {
  override public var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

// Table View Switching

extension TwitterProfileViewController {
  func updateTableViewContent() {
    print("currentIndex did changed \(self.currentIndex)")
  }
  
@objc func segmentedControlValueDidChange(sender: AnyObject?) {
    self.currentIndex = self.segmentedControl.selectedSegmentIndex
    
    let scrollViewToBeShown: UIScrollView! = self.currentScrollView
    
    self.scrollViews.forEach { (scrollView) in
      scrollView?.isHidden = scrollView != scrollViewToBeShown
    }
    
    scrollViewToBeShown.frame = self.computeTableViewFrame(tableView: scrollViewToBeShown)
    self.updateMainScrollViewFrame()
    
    // auto scroll to top if mainScrollView.contentOffset > navigationHeight + segmentedControl.height
    let navigationHeight = self.scrollToScaleDownProfileIconDistance
    let threshold = self.computeProfileHeaderViewFrame().lf_originBottom - navigationHeight
    
    if mainScrollView.contentOffset.y > threshold {
      self.mainScrollView.setContentOffset(CGPoint(x: 0, y: threshold), animated: false)
    }
  }
}

extension TwitterProfileViewController {
  
  var debugMode: Bool {
    return false
  }
  
  func showDebugInfo() {
    if debugMode {
      self.debugTextView = UILabel()
      debugTextView.text = "debug mode: on"
      debugTextView.backgroundColor = UIColor.white
      debugTextView.sizeToFit()
      
      self.view.addSubview(debugTextView)
      
      debugTextView.snp.makeConstraints({ (make) in
        make.right.equalTo(self.view.snp.right).inset(16)
        make.top.equalTo(self.view.snp.top).inset(16)
      })
    }
  }
  
  func debugContentOffset(contentOffset: CGPoint) {
    self.debugTextView?.text = "\(contentOffset)"
  }
}

extension CGRect {
  var lf_originBottom: CGFloat {
    return self.origin.y + self.height
  }
}

// MARK: Public interfaces
extension TwitterProfileViewController {
   @objc public func numberOfSegments() -> Int {
    return 0
  }
  
   @objc public func segmentTitle(forSegment index: Int) -> String {
    return ""
  }
  
   @objc public func prepareForLayout() {
    /* to be override */
  }
  
   @objc public func scrollView(forSegment index: Int) -> UIScrollView {
    return UITableView.init(frame: CGRect.zero, style: .grouped)
  }
}

extension TwitterProfileViewController: TwitterProfileHeaderViewDelegate{
    @objc func refreshData() {
    }
    
    @objc func didTapOnReportButton() {
    }
}

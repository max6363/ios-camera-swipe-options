//
//  iOSSwipeOptions.swift
//  ios-camera-swipe-options
//
//  Created by Minhaz Panara on 05/09/17.
//

import UIKit

protocol iOSSwipeOptionsDelegate {
    func didSwipeToItem(_ item: String, index: Int)
}

class iOSSwipeOptions: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    // params
    var items: Array<String> = []
    var swippableView: UIView!
    var delegate: iOSSwipeOptionsDelegate!
    
    // private
    private let swipe_cell_width = 90 as CGFloat
    private var theCollectionView: UICollectionView!
    private var unitIndex: Int = 0
    private var appliedSwipeGestures: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialize()
    }
    
    private func initialize() {
        
        // setup collection view
        self.setupCollectionView()
    }
    
    func setup() {
        
        // setup collection view
        self.setupCollectionView()
    }
    
    //MARK: - Setup unit collection view
    private var flowlayout : UICollectionViewFlowLayout!
    private func setupCollectionView()
    {
        // swipe gestures
        if swippableView != nil && appliedSwipeGestures == false {
            
            let directions: [UISwipeGestureRecognizerDirection] = [.right, .left]
            for direction in directions {
                let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
                gesture.direction = direction
                swippableView.addGestureRecognizer(gesture)
            }
            
            appliedSwipeGestures = true
        }
        
        // flow layout
        if flowlayout == nil {
            flowlayout = UICollectionViewFlowLayout()
        }
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 0.0
        flowlayout.minimumInteritemSpacing = 5.0
        
        // collection view
        let f = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        if self.theCollectionView == nil {
            
            self.theCollectionView = UICollectionView(frame: f, collectionViewLayout: flowlayout)
            //iOSSwipeItemCell
            self.theCollectionView.register(iOSSwipeItemCell.self, forCellWithReuseIdentifier: "iOSSwipeItemCell")
            self.theCollectionView.allowsMultipleSelection = false
            self.addSubview(self.theCollectionView)
            
        } else {
            self.theCollectionView.frame = f
            self.theCollectionView.collectionViewLayout = flowlayout
        }
        
        // option collection view
        self.theCollectionView.delegate = self
        self.theCollectionView.dataSource = self
        
        // reload
        self.theCollectionView.reloadData()
        
//        self.theCollectionView.setBorder(1, color: UIColor.red)
    }
    
    @objc private func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        
        var prev = NSNotFound
        if recognizer.direction == .left {
            //            print("--> left swipe done")
            if self.unitIndex < (items.count) - 1 {
                prev = self.unitIndex
                self.unitIndex += 1
            }
        }
        else if recognizer.direction == .right {
            //            print("---> right swipe done")
            if self.unitIndex > 0 {
                prev = self.unitIndex
                self.unitIndex -= 1
            }
        }
        if prev != NSNotFound {
            self.deselectItemAtIndex(index: prev)
        }
        self.selectItemAtIndex(index: self.unitIndex)
    }
    
    //MARK: - select item at index
    func selectItemAtIndex(index: Int) {
        if index < items.count {
            // select default index
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView(self.theCollectionView, didSelectItemAt: indexPath)
        }
    }
    
    func deselectItemAtIndex(index: Int) {
        // select default index
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView(self.theCollectionView, didDeselectItemAt: indexPath)
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iOSSwipeItemCell", for: indexPath) as! iOSSwipeItemCell
        cell.setText(self.items[indexPath.item])
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: swipe_cell_width, height: 20)
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // deselect previous
        self.deselectItemAtIndex(index: self.unitIndex)
        
        // all selected items
        let sel_itms = collectionView.indexPathsForSelectedItems
        for itm in sel_itms! {
            self.deselectItemAtIndex(index: itm.item)
        }
        
        // select current
        guard let cell = collectionView.cellForItem(at: indexPath) as? iOSSwipeItemCell else {
            return
        }
        cell.cellSelect()
        self.unitIndex = indexPath.item
        
        // scroll to content offset
        let mid = -self.theCollectionView.frame.size.width/2.0
        let x =  mid + self.swipe_cell_width/2 + CGFloat(self.unitIndex) * self.swipe_cell_width as CGFloat
        let offset = CGPoint(x: x, y: 0)
        self.theCollectionView.setContentOffset(offset, animated: true)
        
        // perform delegate
        self.delegate.didSwipeToItem(self.items[indexPath.item], index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? iOSSwipeItemCell else {
            return
        }
        cell.cellDeselect()
    }

}

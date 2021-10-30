//
//  BooksViewController.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/19.
//

import UIKit

class BooksViewController: UIViewController {

    
    //MARK: Property
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var backgroundColors = [UIColor.blue,
                            UIColor.systemPink,
                            UIColor.systemTeal,
                            UIColor.cyan,
                            UIColor.darkGray,
                            UIColor.green,
                            UIColor.systemIndigo,
                            UIColor.purple,
                            UIColor.orange]
    
    
    //MARK: Method
    func collectionViewConfig() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10.0
        let length = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.itemSize = CGSize(width: length, height: length)
        collectionView.collectionViewLayout = layout
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewConfig()
        
        let nib = UINib(nibName: BooksCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: BooksCollectionViewCell.identifier)
        

    }
}


extension BooksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksCollectionViewCell.identifier, for: indexPath) as? BooksCollectionViewCell else { return UICollectionViewCell() }
        
        
        cell.background.layer.cornerRadius = 10
        cell.background.backgroundColor = backgroundColors.randomElement()
        cell.titleLabel.textColor = .white
        cell.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cell.ratingLabel.textColor = .white
        cell.ratingLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
//        let data = data[indexPath.item]
//        cell.titleLabel.text = data.engTitle
//        cell.ratingLabel.text = String(data.rate!)
//        cell.posterImage.image = UIImage(named: data.image!)
        
        return cell
    }
    
    
}

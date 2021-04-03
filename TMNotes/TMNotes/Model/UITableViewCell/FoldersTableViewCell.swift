//
//  FoldersTableViewCell.swift
//  TMNotes
//
//  Created by Raylee on 10.03.2021.
//

import UIKit

class FoldersTableViewCell: UITableViewCell {
    @IBOutlet weak var foldersCollectionView: UICollectionView!
    var folders = [Folder]()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DispatchQueue.main.async { [self] in
            foldersCollectionView.delegate = self
            foldersCollectionView.dataSource = self
        }
    }

    func setFolders(_ folders: [Folder]) {
        self.folders = folders
        self.foldersCollectionView.reloadData()
    }
}

extension FoldersTableViewCell: UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.folders.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FolderCell", for: indexPath) as? FolderCollectionViewCell
        else { fatalError() }

        cell.setFolder(self.folders[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(
            width: collectionView.frame.height * 1.25,
            height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FolderCollectionViewCell else { return }
        guard let folder = cell.folder else { return }
        guard let navigation = UIApplication.shared.keyWindow?
                .rootViewController as? UINavigationController else { return }

        MainRouter.call(to: navigation, folder: folder, true)
    }
}

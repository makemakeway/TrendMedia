//
//  SimilarContentsViewDelegate.swift
//  TrendMedia
//
//  Created by 박연배 on 2021/10/31.
//

import Foundation

protocol SimilarContentsViewDelegate {
    func similarContentsViewClicked(category: String, id: Int, index: Int)
}

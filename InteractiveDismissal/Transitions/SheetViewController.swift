//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class SheetViewController: UIViewController {

    let contentViewController: UIViewController

    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.view.frame = view.frame
        contentViewController.didMove(toParent: self)

        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
    }
}

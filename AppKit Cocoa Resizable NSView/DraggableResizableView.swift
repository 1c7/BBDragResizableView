//
//  DraggableResizableView.swift
//  AppKit Cocoa Resizable NSView
//
//  Created by Bibin Jacob Pulickal on 11/06/19.
//  Copyright © 2019 Bibin Jacob Pulickal. All rights reserved.
//

import Cocoa
// 加了"最小高度"

// 就是这个了
class DraggableResizableView: NSView {

    private let resizableArea: CGFloat = 4 // 边缘宽度
    
    private let borderPadding: CGFloat = 0 // 拖动整个框时，和边框的距离，如果设置为0就是可以贴着边
    private var draggedPoint: CGPoint  = .zero // 类型 CGPoint
    
    var topleft, bottomright: NSCursor?;
    var topright, bottomleft: NSCursor?;
    
    var minimum_height: CGFloat = 20;
    var minimun_width = 20;

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        backgroundColor = .red // 初始化是红色
        let string: NSString = "hello world"
//        string.draw(in: NSPoint(x: 0, y: 0), withAttributes: nil)//no
        let attr: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 27)
        ]
        string.draw(in: NSRect(x: 0, y: 0, width: 100, height: 200), withAttributes: attr)
//        let img = NSImage.("resize-1")
//        bottomright = NSCursor.init(image: img, hotSpot: NSPoint(x: 0,y: 0))
        
        let mag_gesture = NSMagnificationGestureRecognizer(target: self, action: #selector(mag))
        self.addGestureRecognizer(mag_gesture)
        
//        let pan_gesture = NSPanGestureRecognizer(target: self, action: #selector(pan))
//        self.addGestureRecognizer(pan_gesture)
        
//        let rotate_gesture = NSRotationGestureRecognizer(target: self, action: #selector(rotate2))
//        self.addGestureRecognizer(rotate_gesture)
        
//        let press_gesture = NSPressGestureRecognizer(target: self, action: #selector(press2))
//        self.addGestureRecognizer(press_gesture)
        
//        let file_path = "/Users/remote_edit/Desktop/1.jpg"
//        let image = NSImage.init(contentsOfFile: file_path)
//        image?.draw(in: NSRect(x: 0, y: 0, width: 200, height: 300))
//        image?.draw(at: NSPoint(x: 0, y: 0), from: frameRect, operation: NSCompositingOperation.color, fraction: 1.0)
        
//        let image_url = "https://i.redd.it/9q7f19slipn51.jpg"
        let image_url = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600413007785&di=83ca992c58eb6c59c57ed89541860d36&imgtype=0&src=http%3A%2F%2Ftheemilybloom.com%2Fwp-content%2Fuploads%2F2016%2F01%2FBanner.jpg"
        let image = NSImage(byReferencing: URL(string: image_url)!)
        let image_view = NSImageView(frame: NSRect(x: 0, y: 0, width: 100, height: 200))
        image_view.image = image
        image_view.frame = NSRect(x: 30, y: 30, width: 100, height: 100)
//        image_view.image = NSImage.init(contentsOf: URL(string: image_url)!)
        addSubview(image_view)
    }
    
    @objc
    func press2(with event: NSEvent){
        print("press")
        print(event.pressure)
    }
    
    @objc
    func mag(with event: NSEvent){
//        print("mag")
//        print(event)
        print(event.magnification)
        let base: CGFloat = 10.0
        let value = base * event.magnification
        print(value)
        print(size.width)
        print(size.height)

        if(value > 0){
            if(size.width < 200 && size.height < 200){
            size.height += value
            size.width += value
            }
        } else {
            if(size.width > 90 && size.height > 90){
                size.height += value
                size.width += value
            }
        }






    }
    
    @objc
    func pan(with event: NSEvent){
        print(event)
        print(event.buttonMask)
//        print(event.)
    }
    
    override func scrollWheel(with event: NSEvent) {
//        print(event.deltaX)
        print(event.deltaY)
//        print(event.deltaZ)
    }
    
    @objc
    func rotate2(with event: NSEvent) {
        print(event)
        print(event.rotation)
    }

    // 为什么需要这个 updateTrackingAreas?
    // 貌似是当大小和坐标改变后，需要更新这个  tracking area
//    http://www.tanhao.me/pieces/1808.html/
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { area in
            removeTrackingArea(area)
        }
        addTrackingRect(bounds)
    }

//   为什么要这个？
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // enter 只是改个颜色和边框
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        backgroundColor = .green
        borderColor     = .white
        borderWidth     = 1
//        NSCursor.resizeDown
    }

    // 离开：去掉边框
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        NSCursor.arrow.set()
//        backgroundColor = .red
        borderColor     = .clear
        borderWidth     = 0
    }

    // 这次搞清楚 convert 大概是什么了
//    保存 drag point
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        // 那么到底 convert 了个啥?
        print(event.locationInWindow)
        let locationInView = convert(event.locationInWindow, from: nil)
        draggedPoint            = locationInView
        print(draggedPoint)
        // 变成了相对位置，点击位置相对于自己的
    }
    // down 的时候保存 相对位置

    // up 就不用  drag 了
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        draggedPoint = .zero
    }

    // move 的时候干啥了？
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        let locationInView = convert(event.locationInWindow, from: nil)
        cursorBorderPosition(locationInView)
        // 这个应该是判断是不是到了边缘，如果是，改 cursor
    }

    // drag 代码可多了
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event) // super 是必须的吗？
        
        backgroundColor                 = .green
        borderWidth                     = 1
        //
        
        let locationInView              = convert(event.locationInWindow, from: nil)
        let horizontalDistanceDragged   = locationInView.x - draggedPoint.x
        let verticalDistanceDragged     = locationInView.y - draggedPoint.y
        let cursorPosition              = cursorBorderPosition(draggedPoint)
        
        // 如果是边缘
        if cursorPosition != .none {
            let drag    = CGPoint(x: horizontalDistanceDragged, y: verticalDistanceDragged)
            // 是 border 就不 drag 了
            if checkIfBorder(cursorPosition, andDraggedOutward: drag) {
                return
            }
        }
        // 如果是边缘
        switch cursorPosition {
        case .top:
            if(verticalDistanceDragged < 0){
                if(frame.size.height <= minimum_height){
                    break
                }
            }

            size.height += verticalDistanceDragged
            draggedPoint = locationInView
            // 是顶部就直接改高度
            // 要重设 dragging point 否则判断位置不太好用？
        case .left:
            origin.x    += horizontalDistanceDragged
            size.width  -= horizontalDistanceDragged
            // 弄清楚为啥是 + x
        case .bottom:
            if(verticalDistanceDragged > 0){
                if(frame.size.height <= minimum_height){
                    break
                }
            }
            origin.y    += verticalDistanceDragged
            size.height -= verticalDistanceDragged
            
        case .right:
            size.width  += horizontalDistanceDragged
            draggedPoint = locationInView
        case .none:
            // 如果不是边缘
            origin.x    += locationInView.x - draggedPoint.x
            origin.y    += locationInView.y - draggedPoint.y
            repositionView()
        }
    }

//    @discardableResult 是什么？必要吗？
//    是为了让  XCode 闭嘴
//    暂不支持在角落里同时缩放宽和高, 在  corner 不行
    // return 一个 enum
    @discardableResult
    func cursorBorderPosition(_ locationInView: CGPoint) -> BorderPosition {
        if locationInView.x < resizableArea {
            NSCursor.resizeLeftRight.set()
            return .left
        } else if locationInView.x > bounds.width - resizableArea {
            NSCursor.resizeLeftRight.set()
            return .right
        } else if locationInView.y < resizableArea {
            NSCursor.resizeUpDown.set()
            return .bottom
        } else if locationInView.y > bounds.height - resizableArea {
            NSCursor.resizeUpDown.set()
            return .top
        } else {
            NSCursor.arrow.set()
            return .none
        }
    }

    enum BorderPosition {
        case top, left, bottom, right, none
    }

    // 检查是不是边界
    private func checkIfBorder(_ border: BorderPosition,
                               andDraggedOutward drag: CGPoint) -> Bool {
        if border == .left && frame.minX <= borderPadding && drag.x < 0 {
            return true
        }
        if border == .bottom && frame.minY <= borderPadding && drag.y < 0 {
            return true
        }
        guard let superView = superview else { return false }
        if border == .right && frame.maxX >= superView.frame.maxX - borderPadding && drag.x > 0 {
            return true
        }
        if border == .top && frame.maxY >= superView.frame.maxY - borderPadding && drag.y > 0 {
            return true
        }
        return false
    }

    // 这是改 origin? NSView 上没看到这个属性
//    但猜测是的
    private func repositionView() {
        if frame.minX < borderPadding {
            origin.x    = borderPadding
        }
        if frame.minY < borderPadding {
            origin.y    = borderPadding
        }
        guard let superView = superview else { return }
        if frame.maxX > superView.frame.maxX - borderPadding {
            origin.x    = superView.frame.maxX - frame.width - borderPadding
        }
        if frame.maxY > superView.frame.maxY - borderPadding {
            origin.y    = superView.frame.maxY - frame.height - borderPadding
        }
    }
}

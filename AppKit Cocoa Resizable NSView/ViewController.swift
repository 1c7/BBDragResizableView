//
//  ViewController.swift
//  AppKit Cocoa Resizable NSView
//
//  Created by Bibin Jacob Pulickal on 06/06/19.
//  Copyright © 2019 Bibin Jacob Pulickal. All rights reserved.
//

import Cocoa
import AutoLayoutProxy

//这个是主要的
class ViewController: NSViewController {
    var ivTest = NSImageView()

    private let draggableResizableView = DraggableResizableView()
    // 生成一个  drag resizeable view

    // 这个 loadView 是什么鬼
//    加了一个 drag resizeable view + 一个按钮进去
    override func loadView() {
        view        = NSView()
        view.size >= 500
        view.addSubview(NSButton(title: "重置", target: self, action: #selector(resetFrame))) {
            $0.centerX == $1.centerX
        }// 这是直接加了个按钮?
        view.addSubview(draggableResizableView)
        
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(resetFrame), with: nil, afterDelay: 1)
        // 这个 perform 是什么
        
        
        // 图片的4个实验
//        add_local_image() // 本地文件系统
//        add_network_image() // 网络
//        add_inner_image() // 代码内
        add_asset_image() // asset 内
    }
    
    // 核心 NSImage 直接用 asset 里的图片
    func add_asset_image(){
        self.view.addSubview(self.ivTest)
        self.ivTest.wantsLayer = true
        self.ivTest.layer?.backgroundColor = NSColor.systemPink.cgColor
        self.ivTest.layer?.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        self.ivTest.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        
        
        let image = NSImage(named: NSImage.Name("fu"))
        guard image != nil else {
            print("错啦")
            return
        }
        
        if (image!.isValid == true){
            print("valid")
            print("image size \(image!.size.width):\(image!.size.height)")
            self.ivTest.image = image
        } else {
            print("not valid")
        }
    }
    
    // 核心: Bundle for resource
    func add_inner_image(){
        self.view.addSubview(self.ivTest)
        self.ivTest.wantsLayer = true
        self.ivTest.layer?.backgroundColor = NSColor.systemPink.cgColor
        self.ivTest.layer?.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        self.ivTest.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        
        let str = "luisa-brimble-gBNRcViwHwQ-unsplash.jpg"
        let b = Bundle.main.path(forResource: str, ofType: nil)
        
        let image: NSImage = NSImage(contentsOfFile: b!)!
        
        if (image.isValid == true){
            print("valid")
            print("image size \(image.size.width):\(image.size.height)")
            self.ivTest.image = image
        } else {
            print("not valid")
        }
    }
    
    // 核心: 加载 URL 图片
    func add_network_image(){
        self.view.addSubview(self.ivTest)
        self.ivTest.wantsLayer = true
        self.ivTest.layer?.backgroundColor = NSColor.systemPink.cgColor
        self.ivTest.layer?.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        self.ivTest.frame = NSRect(x: 0, y: 0, width: 100, height: 100)

        let url = URL(string: "https://i.redd.it/e1o0wia7vbn51.jpg")
        let image: NSImage = NSImage(contentsOf: url!)!
        
        if (image.isValid == true){
            print("valid")
            print("image size \(image.size.width):\(image.size.height)")
            self.ivTest.image = image
        } else {
            print("not valid")
        }
    }
    
    // 核心: file mangage 拼接连接 + 取消 sandbox
    func add_local_image(){
        self.view.addSubview(self.ivTest)
        self.ivTest.wantsLayer = true
        self.ivTest.layer?.backgroundColor = NSColor.systemPink.cgColor
        self.ivTest.layer?.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        self.ivTest.frame = NSRect(x: 0, y: 0, width: 100, height: 100)

        let manager = FileManager.default
        var url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        url = url?.appendingPathComponent("night.jpg")
        
        let image = NSImage(byReferencing: url!)
        if (image.isValid == true){
            print("valid")
            print("image size \(image.size.width):\(image.size.height)")
            self.ivTest.image = image
        } else {
            print("not valid")
        }
    }

    @objc func resetFrame() {
        let width                               = view.bounds.width / 5
        let height                              = view.bounds.height / 5
        let x                                   = (view.bounds.width - width) * 0.5
        let y                                   = (view.bounds.height - height) * 0.5
        draggableResizableView.frame            = CGRect(x: x, y: y, width: width, height: height)
        draggableResizableView.autoresizingMask = [.minXMargin, .minYMargin, .maxXMargin, .maxYMargin]
    }
}

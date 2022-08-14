//
//  ViewController.swift
//  Let's_Start_Combine_Project
//
//  Created by 新垣 清奈 on 2022/08/14.
//

import UIKit
import Combine
import CombineCocoa

class ViewController: UIViewController {

    let subject = PassthroughSubject<String, Never>()
    var subscriptions = Set<AnyCancellable>()
    var value: String = "" {
        didSet {
            print("didSet:", value)
        }
    }
    let publisher = [1 ... 10].publisher
    let publisher2 = Timer.publish(every: 100, on: .main, in: .common)
    let subjectWithBuffer = CurrentValueSubject<String, Never>("AIUEO")
    let combine1 = PassthroughSubject<String, Never>()
    let combine2 = PassthroughSubject<String, Never>()
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        return button
    }()
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .darkGray
        label.text = "Default"
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(button)
        view.addSubview(label)
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        button.frame = CGRect(x: (view.frame.width/2)-100, y: view.frame.height/2, width: 200, height: 50)
        label.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 50)
    }

    @objc func tappedButton(){
        button.tapPublisher
            .sink {[weak self] _ in
                self?.label.text = "Button Tapped!!"
            }
            .store(in: &subscriptions)
    }

    func bind(){
        let _combine2 = combine2.eraseToAnyPublisher()
        let _combine1 = combine1.eraseToAnyPublisher()
        _combine1
            .combineLatest(_combine2)
            .sink { one, two in
                print("My name is \(one). I'm \(two) years old.")
            }
            .store(in: &subscriptions)

        combine1.send("Seina")
        combine2.send("22")

        let anyPublisher = subject.eraseToAnyPublisher()
        anyPublisher
            .sink { value in
                print("erased:\(value)")
            }
            .store(in: &subscriptions)

        subjectWithBuffer
            .sink { value in
                print("value:\(value)")
            }
            .store(in: &subscriptions)

        publisher2
            .autoconnect()
            .sink { value in
                print("date:", value)
            }
            .store(in: &subscriptions)

        publisher
            .sink { value in
                print("publisher:", value)
            }
            .store(in: &subscriptions)

        subject
            .assign(to: \.value, on: ViewController())
            .store(in: &subscriptions)

        subject
            .sink { completion in
                print(completion)
            } receiveValue: { value in
                print(value)
            }
            .store(in: &subscriptions)

        subject.send("a")
        subject.send("i")
        subject.send("u")
        subject.send("e")
        subject.send("o")

        subjectWithBuffer.send("a")
        subjectWithBuffer.send("i")
        subjectWithBuffer.send("u")
        subjectWithBuffer.send("e")
        subjectWithBuffer.send("o")
    }


}


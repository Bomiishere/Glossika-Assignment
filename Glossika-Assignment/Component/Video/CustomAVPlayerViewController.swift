//
//  CustomAVPlayerViewController.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/21.
//

import SwiftUI
import AVKit
import Combine

class CustomAVPlayerViewController: AVPlayerViewController, AVPlayerViewControllerDelegate {
    
    private var playPauseButton: UIButton!
    private var slider: UISlider!
    private var volumeButton: UIButton!
    private var controlContainerView: UIView!
    private var fullScreenTapGesture: UITapGestureRecognizer!
    
    private let soundManager = SoundManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(player: AVPlayer) {
        super.init(nibName: nil, bundle: nil)
        self.player = player
        self.player?.volume = soundManager.volume
        self.showsPlaybackControls = false
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addObservers()
        
        controlContainerView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
        
        fullScreenTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFullScreenTap))
        fullScreenTapGesture.numberOfTapsRequired = 1
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    //MARK: Target Action
    @objc private func togglePlayPause() {
        if player?.timeControlStatus == .playing {
            player?.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc private func toggleSound() {
        soundManager.toggleSound()
    }
    
    @objc private func sliderValueChanged() {
        let duration = CMTimeGetSeconds(player?.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let value = Float64(slider.value) * duration
        let seekTime = CMTimeMakeWithSeconds(value, preferredTimescale: 1000)
        player?.seek(to: seekTime)
    }
    
    @objc private func handleTapGesture() {
        controlContainerView.isHidden.toggle()
        if controlContainerView.isHidden {
            view.removeGestureRecognizer(fullScreenTapGesture)
        } else {
            view.addGestureRecognizer(fullScreenTapGesture)
        }
    }
    
    @objc private func handleFullScreenTap() {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first else { return }
        
        let playerViewController = AVPlayerViewController()
        let newPlayer = AVPlayer(url: (player?.currentItem?.asset as? AVURLAsset)?.url ?? URL(string: "")!)
        playerViewController.player = newPlayer
        playerViewController.modalPresentationStyle = .fullScreen
        playerViewController.delegate = self
        rootViewController.present(playerViewController, animated: true) {
            newPlayer.play()
        }
    }
    
    //MARK: Private
    private func addObservers() {
        soundManager.$volume.sink { [weak self] newVolume in
            if let `self` = self {
                self.player?.volume = newVolume
                DispatchQueue.main.async {
                    let icon = UIImage(systemName: newVolume == 0 ? "speaker.slash.fill" : "speaker.fill")
                    self.volumeButton.setImage(icon, for: .normal)
                }
            }
        }.store(in: &cancellables)
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 2), queue: .main) { [weak self] time in
            let duration = CMTimeGetSeconds(self?.player?.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            let currentTime = CMTimeGetSeconds(time)
            self?.slider.value = Float(currentTime / duration)
        }
    }
    
    private func setupUI() {
        controlContainerView = UIView()
        controlContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlContainerView.backgroundColor = UIColor.clear
        view.addSubview(controlContainerView)
        
        playPauseButton = createButton(systemName: "pause.fill", action: #selector(togglePlayPause))
        
        volumeButton = createButton(systemName: soundManager.isMuted ? "speaker.slash.fill" : "speaker.fill", action: #selector(toggleSound))
        volumeButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        volumeButton.layer.cornerRadius = 16
        volumeButton.layer.masksToBounds = true
        
        slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .gray
        slider.setThumbImage(UIImage(), for: .normal)
        
        controlContainerView.addSubview(playPauseButton)
        controlContainerView.addSubview(slider)
        controlContainerView.addSubview(volumeButton)
        
        NSLayoutConstraint.activate([
            controlContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            controlContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            playPauseButton.centerXAnchor.constraint(equalTo: controlContainerView.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 44),
            playPauseButton.heightAnchor.constraint(equalToConstant: 44),
            
            slider.leadingAnchor.constraint(equalTo: controlContainerView.leadingAnchor, constant: -1),
            slider.trailingAnchor.constraint(equalTo: controlContainerView.trailingAnchor, constant: 1),
            slider.bottomAnchor.constraint(equalTo: controlContainerView.bottomAnchor),
            
            volumeButton.widthAnchor.constraint(equalToConstant: 32),
            volumeButton.heightAnchor.constraint(equalToConstant: 32),
            volumeButton.trailingAnchor.constraint(equalTo: controlContainerView.trailingAnchor, constant: -16),
            volumeButton.bottomAnchor.constraint(equalTo: controlContainerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func createButton(systemName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        let icon = UIImage(systemName: systemName)
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        
        if let imageView = button.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            let padding: CGFloat = 8
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: padding),
                imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -padding),
                imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: padding),
                imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -padding)
            ])
        }
        return button
    }
}

struct CustomAVPlayerViewControllerRepresentable: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> CustomAVPlayerViewController {
        let controller = CustomAVPlayerViewController(player: player)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CustomAVPlayerViewController, context: Context) {
        // 更新播放器
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CustomAVPlayerViewControllerRepresentable
        
        init(_ parent: CustomAVPlayerViewControllerRepresentable) {
            self.parent = parent
        }
    }
}

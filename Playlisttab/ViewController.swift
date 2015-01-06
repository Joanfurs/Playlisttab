//
//  ViewController.swift
//  Playlisttab
//
//  Created by Zhanna Fursova on 12/22/14.
//  Copyright (c) 2014 John Doe. All rights reserved.
//


import UIKit;
import AVFoundation;	//for AVAudioPlayer

class ViewController: UIViewController {
	var audioPlayer: AVAudioPlayer?;
	let text: String;

	init(title: String, badge: String, mp3: String, text: String) {
		self.text = text;
		super.init(nibName: nil, bundle: nil);
		self.title = title;
		tabBarItem.badgeValue = badge;
		tabBarItem.image = UIImage(named: "icon");
		
		let bundle: NSBundle = NSBundle.mainBundle();
		let path: String = bundle.pathForResource(mp3, ofType: "mp3")!
		let url: NSURL = NSURL(fileURLWithPath: path, isDirectory: false)!;
		var error: NSError?;
		audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error);
		if audioPlayer == nil {
			println("\(title) could not create AVAudioPlayer: \(error!).");
			return;
		}

		if !audioPlayer!.prepareToPlay() {	//left ! means "not"
			println("could not prepare to play.");

	}
	}

	//Not called
	required init(coder aDecoder: NSCoder) {
		text = "";
		super.init(coder: aDecoder);
	}

	override func loadView() {
	
	 	view = View(text: text, viewController: self);
		
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let displayLink: CADisplayLink? = CADisplayLink(target: self, selector: "updateSlider:");
		displayLink!.frameInterval = 1;
		let loop: NSRunLoop = NSRunLoop.currentRunLoop();
		displayLink!.addToRunLoop(loop, forMode: NSDefaultRunLoopMode);
	}
	
	func updateSlider(displayLink: CADisplayLink) {
		assert(audioPlayer!.duration > 0);	//Can't divide by zero.
		let v: View = view as View;
		//Move the slider's thumb to the curent location in the audio file.
		//The quotient is a fraction in the range 0 to 1 inclusive.
		v.slider.value = Float(audioPlayer!.currentTime / audioPlayer!.duration);
	}

	
	func valueChanged(slider: UISlider!) {
		audioPlayer!.currentTime = NSTimeInterval(slider.value) * audioPlayer!.duration;
	}
	
	
	func valueChanged2(slider2: UISlider!) {
		audioPlayer!.volume = slider2.value
	}

	
	func play(button: UIButton!) {
	
		var title: String? = button.titleForState(UIControlState.Normal);
		if title == nil {
			title = "untitled";
		}
		println("play = \(title!)");
		

		if !audioPlayer!.prepareToPlay() {
			println("could not prepare to play");
			return;
		}

		if !audioPlayer!.play() {
			println("could not prepare to play");
	}
	}
	
	func pause(button2: UIButton!) {
	
		var title: String? = button2.titleForState(UIControlState.Normal);
		if title == nil {
			title = "untitled";
		}
		println("pause = \(title!)");

		audioPlayer!.pause()
	}
	
	func stop(button3: UIButton!) {
	
		var title: String? = button3.titleForState(UIControlState.Normal);
		if title == nil {
			title = "untitled";
		}
		println("stop = \(title!)");

		audioPlayer!.stop()
		audioPlayer!.currentTime = 0
	}
	
	func mute(button4: UIButton!) {
	
		var title: String? = button4.titleForState(UIControlState.Normal);
		if title == nil {
			title = "untitled";
		}
		println("stop = \(title!)");

		if audioPlayer!.volume > 0.0 {
		audioPlayer!.volume = 0.0
	} else {
		audioPlayer!.volume = 0.5
		}
	}

	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
		println("\(title!) did appear.");
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated);
		println("\(title!) will disappear.");

		if audioPlayer != nil {
			audioPlayer!.stop();
			if !audioPlayer!.prepareToPlay() {
				println("could not prepare to play.");
			}
		}
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

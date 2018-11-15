import UIKit

class ViewController:
        UIViewController,
        UIDocumentPickerDelegate,
        UINavigationControllerDelegate {
    
    @IBOutlet var playStopButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var roomSizeValueLabel: UILabel!
    @IBOutlet var lowCutoffValueLabel: UILabel!

    @IBOutlet var roomSizeSlider: UISlider!
    @IBOutlet var lowCutoffSlider: UISlider!

    var fileURL: URL?
    
    var audioEngine: DemoAudioEngineBindings   // 1
    
    required init?(coder aDecoder: NSCoder) {

        audioEngine = DemoAudioEngineBindings()     // 1
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomSizeValueLabel.text = "\(roomSizeSlider.value)"
        lowCutoffValueLabel.text = "\(lowCutoffSlider.value)"
        
        audioEngine.setPlaybackDidFinish({() -> Void in     // 3
            self.didFinishPlaying()
        })
        
        let waveformBounds = CGRect(x: 25,                      // 2
                                    y: self.view.bounds.size.height * 0.7,
                                    width: self.view.bounds.size.width - 50,
                                    height: self.view.bounds.size.height * 0.25)
        
        audioEngine.setWaveformComponentBounds(waveformBounds)  // 2
        
    }

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.fileURL = url as URL
        print("import result : \(String(describing: fileURL))")
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("document picker was cancelled")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func loadFileButtonClicked() {
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: UIDocumentPickerMode.open)
        
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.title = "Choose an audio file"
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func didFinishPlaying()
    {
        self.playStopButton.setTitle("Play", for: UIControl.State.normal)
        self.statusLabel.text = "Stopped"
    }
    
    @IBAction func playButtonClicked() {
        self.audioEngine.play (self.fileURL?.absoluteString)  // 1
        self.playStopButton.setTitle("Stop", for: UIControl.State.normal)
        self.statusLabel.text = "Playing file..."
    }
    
    @IBAction func pauseButtonClicked() {
        self.audioEngine.pause() // 1
    }
    
    @IBAction func resumeButtonClicked() {
        self.audioEngine.resume() // 1
    }
    
    @IBAction func showButtonClicked() {
        audioEngine.addWaveformComponent (to: self.view)        // 2
    }
    
    @IBAction func hideButtonClicked() {
        audioEngine.removeWaveformComponent (from: self.view)        // 2
    }
    
    @IBAction func roomSizeSliderValueChanged(sender: UISlider) {
        let roomSizeValue = sender.value
        print("Room Size slider changing to \(roomSizeValue)")
        
        DispatchQueue.main.async {
            self.roomSizeValueLabel.text = "\(roomSizeValue)"
        }
        
        self.audioEngine.setRoomSize (roomSizeValue)   // 1
    }

    @IBAction func lowCutoffSliderValueChanged(sender: UISlider) {
        let lowCutoffValue = sender.value
        print("Cutoff slider changing to \(lowCutoffValue)")
        
        DispatchQueue.main.async {
            self.lowCutoffValueLabel.text = "\(lowCutoffValue)"
        }
        
        self.audioEngine.setLowpassCutoff (lowCutoffValue)  // 1
    }

}


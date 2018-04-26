import XCTest

@testable import VeriFoneDetector

class VeriFoneDetectorTests: XCTestCase {

   override func setUp() {
       super.setUp()
       // Put setup code here. This method is called before the invocation of each test method in the class.
   }

   override func tearDown() {
       // Put teardown code here. This method is called after the invocation of each test method in the class.
       super.tearDown()
   }

    func testNetworkScannerRunner() {
        
        var shouldContinue = true
        //let runner = NetworkScannerRunner(delegate: nil, shouldStartScan: true)
        
        //        while (shouldContinue) {
        //            if let done = runner.scanner?.isComplete {
        //                if done {
        //                    shouldContinue = false
        //                }
        //            }
        //
        //            if (shouldContinue) {
        //                // TODO: can we stop it faster?
        //                RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture)
        //            }
        //        }
        
        //print(runner.scanner?.retrieveResult())
        
        
        
        //        scanner.startScan()
        //
        //        while (shouldContinue) {
        //            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture)
        //        }
        
        
        //sleep(10)
        
        //        DispatchQueue.global(qos: .default).async {
        //            result = scanner.startScan()
        //            print(result)
        //        }
        //
        //        sleep(10) // TODO: make this work nicer; tried several approaches; not working yet.
        //        result = scanner.retrieveResult()
        //        print(result)
        
        //        scanner.startAsyncScan(completion: { result in print(result) })
        
        
        //let fetchLocation = CLLocationManager.requestLocation().lastValue
        
        //        firstly {
        //            result = scanner.startAsyncScan()
        //        }.then { creds in
        //            print("here")
        //        }.done { image in
        //            print(result)
        //        }
        
        //        let queue = DispatchQueue(label: "network.scanner")
        //        queue.async {
        //            result = scanner.startScan()
        //            print(result)
        //        }
        //
        //        sleep(10)
        
        
        
        
        
        //        var complete = false
        //
        //
        //        // get a global concurrent queue
        //        let queue = DispatchQueue.global(qos: .default)
        //        // submit a task to the queue for background execution
        //        queue.async() {
        //            // update UI on the main queue
        //            let result = scanner.startScan()
        //            DispatchQueue.main.async() {
        //                complete = true
        //            }
        //        }
        //
        //        while !complete {
        //            usleep(1000)
        //        }
        
        // TODO: this is not really nice; so far threading issues seem to pop up
        // using the MMLanScan pod
        
        
        
        //        let group = DispatchGroup()
        //        group.enter()
        //
        //        let block = DispatchWorkItem(flags: .inheritQoS) { // 3
        //            result = scanner.startScan()
        //            group.leave()
        //        }
        //
        //        DispatchQueue.main.async(execute: block)
        //
        //        print(result)
        
        //        let asyncOperation = AsyncOperation(numberOfSimultaneousActions: 1, dispatchQueueLabel: "network.scanner")
        //        asyncOperation.whenCompleteAll = {
        //            print("All Done")
        //        }
        //        asyncOperation.run{ completeClosure in
        //            // add any (sync/async) code
        //            //..
        //            let scanner = NetworkScanner()
        //            let result = scanner.startScan()
        //            // Make signal that this closure finished
        //            completeClosure()
        //        }
        
        
        //        var myContext = 0
        //        scanner.addObserver(self, forKeyPath: "scanComplete", options: .new, context:&myContext)
        
        //result = async{ return scanner.startScan() }
        //print(result)
        
        
        //        let queue = DispatchQueue(label: "network.scanner")
        //        let group = DispatchGroup()
        //
        //
        //        let queue = DispatchQueue(label: )
        //        queue.async {
        //            result = scanner.startScan()
        //        }
        //
        //        print(result)
        
        //        let group = DispatchGroup()
        //        group.enter()
        //
        //        // avoid deadlocks by not using .main queue here
        //        DispatchQueue.global(qos: .background).async {
        //            result = scanner.startScan()
        //            group.leave()
        //        }
        //
        //        // wait ...
        //        group.wait()
        //
        //        // ... and return as soon as "a" has a value
        //        print(result)
        
        //sleep(10)
        
        //scanner.addObserver(self, forKeyPath: "scanComplete", options: .new, context: 0)
        
        //        self.presenter.addObserver(self, forKeyPath: "connectedDevices", options: .new, context:&myContext))
        
        //sleep(10)
        //result = scanner.startScan()
        //print(result)
        
        //print(scanner.retrieveResult())
        //print(result)
        //        while !scanner.isDone() {
        //            usleep(1000)
        //        }
        
        //        let result2 = scanner.retrieveResult()
        //        print(result2)
    }
    
    
    func testVerifoneRecognizerWithSingleIp() {
        
        let ip = "127.0.0.1"
        let emulator = VerifoneEmulator(ip: ip)
        emulator.start()
        
        sleep(1)  // Allow some time to start servers in background
        
        let recognizer = VerifoneRecognizer()
        
        let result = recognizer.check(ip: ip)
        
        XCTAssertTrue(result)
        
        emulator.stop()
    }
    
    func testVerifoneRecognizerWithMultipleIps() {
        
        let ip = "127.0.0.1"
        let emulator = VerifoneEmulator(ip: ip)
        emulator.start()
        
        sleep(1) // Allow some time to start servers in background
        
        let recognizer = VerifoneRecognizer()
        
        let result = recognizer.check(ips: ["127.0.0.1", "127.0.0.2"])
        XCTAssertTrue(result["127.0.0.1"]!)
        XCTAssertFalse(result["127.0.0.2"]!)
        
        emulator.stop()
    }
    
    func testVerifoneRecognizerWithMultipleIpsFromDictionary() {
        
        let ip = "127.0.0.1"
        let emulator = VerifoneEmulator(ip: ip)
        emulator.start()
        
        sleep(1) // Allow some time to start servers in background
        
        let recognizer = VerifoneRecognizer()
        
        let result = recognizer.check(dictionaryOfIps: [1: "127.0.0.1", 2:"127.0.0.2"])
        XCTAssertTrue(result[1]!)
        XCTAssertFalse(result[2]!)
        
        emulator.stop()
    }
    
    //    func testVerifoneDetector() {
    //
    //        let emulatorIp = getIPAddress()
    //        let emulator = VerifoneEmulator(ip: emulatorIp!)
    ////        emulator.start()
    //
    //        sleep(1) // Allow some time to start servers in background
    //
    //        var shouldContinue = true
    //        let detector = VerifoneDetector()
    //        detector.startDetection()
    //
    //        while (shouldContinue) {
    //            if let done = detector.runner.scanner?.isComplete {
    //                if done {
    //                    shouldContinue = false
    //                }
    //            }
    //
    //            if (shouldContinue) {
    //                // TODO: can we stop it faster?
    //                RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture)
    //            }
    //
    //        }
    //
    //        emulator.stop()
    //    }
    
    func testRunEmulator () {
        let emulatorIp = getIPAddress()
        let emulator = VerifoneEmulator(ip: emulatorIp!)
        emulator.start()
        
        sleep(30) // Allow some time to start servers in background
        
        
        emulator.stop()
        
        
    }
    
    //MARK: - KVO
    //This is the KVO function that handles changes on MainPresenter
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //
    //        if (context == &myContext) {
    //
    //            switch keyPath! {
    //            case "scanComplete":
    //                //self.tableV.reloadData()
    //                break
    //            default:
    //                print("Not valid key for observing")
    //            }
    //
    //        }
    //    }
    
}

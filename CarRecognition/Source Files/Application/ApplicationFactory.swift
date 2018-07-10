//
//  ApplicationFactory.swift
//  CarRecognition
//


/// Factory class that creates view controllers with proper dependencies
internal final class ApplicationFactory {
    
    private let applicationDependencies: ApplicationDependencies
    
    /// Initializes the factory with given dependencies
    ///
    /// - Parameter applicationDependencies: Dependencies used for creating controllers
    init(applicationDependencies: ApplicationDependencies) {
        self.applicationDependencies = applicationDependencies
    }
    
    /// Creates controller with live camera AR view and bottom classification preview
    ///
    /// - Returns: Created controller
    func recognitionViewController() -> RecognitionViewController {
        return RecognitionViewController(
            augmentedRealityViewController: augmentedRealityViewController(),
            classificationService: CarClassificationService()
        )
    }
    
    /// Creates controller with live augmented readlity camera preview
    ///
    /// - Returns: Created controller
    func augmentedRealityViewController() -> AugmentedRealityViewController {
        return AugmentedRealityViewController(viewMaker: AugmentedRealityView())
    }
    
    /// Creates controller with list of available cars to discover
    ///
    /// - Parameter scannedCar: Optional which indicates wheter the view is initialized with scanned car or not
    /// - Returns: Created controller
    func carsListViewController(with scannedCar: Car? = nil) -> CarsListViewController {
        return CarsListViewController(viewMaker: CarsListView(car: scannedCar))
    }
}

//
//  InputNormalizationService.swift
//  CarRecognition
//


internal final class InputNormalizationService {
    
    private let numberOfValuesToAverageCalculation: Int
    private lazy var normalizationValue = 1.0 / Double(numberOfValuesToAverageCalculation)
    private lazy var lastValues = [Double](repeating: 0.0, count: numberOfValuesToAverageCalculation)
    
    /// Initializes the normalizer
    ///
    /// - Parameter numberOfValues: Number of last saved values that will be used for normalization
    init(numberOfValues: Int) {
        self.numberOfValuesToAverageCalculation = numberOfValues
    }
    
    /// Normalizes given value
    ///
    /// - Parameter value: Value to be normalized
    /// - Returns: Normalized value
    func normalize(value: Double) -> Double {
        lastValues.insert(value, at: 0)
        lastValues.removeLast()
        
        var average = 0.0
        lastValues.forEach { average += $0 * normalizationValue }
        return average
    }
}
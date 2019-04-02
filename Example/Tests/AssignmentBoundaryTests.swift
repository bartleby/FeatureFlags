//
//  AssignmentBoundaryTests.swift
//  FeatureFlags
//
//  Created by Ross Butler on 12/9/18.
//

import XCTest
@testable import FeatureFlags

/// Testing that given a test variation assignment that the user is assigned to the correct A/B testing group.
// swiftlint:disable:next type_body_length
class AssignmentBoundaryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWhenTestVariationAssignmentIsZeroThatVariationIsGroupA() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [50, 50],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
            XCTAssert(false, "Fail")
            return
        }
        feature.testVariationAssignment = 0.0
        XCTAssert(feature.isTestVariation(.groupA), "Pass")
        XCTAssert(!feature.isTestVariation(.groupB), "Pass")
    }

    func testWhenFeatureABEnabledAndAssignmentIsZeroThatInTestVariationEnabled() {
        let featureConfiguration =
        """
        [{
        "name": "Example Feature A/B Test",
        "enabled": true,
        "test-variations": ["Enabled", "Disabled"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 0.0
        XCTAssert(feature.isTestVariation(.enabled), "Pass")
        XCTAssert(!feature.isTestVariation(.disabled), "Pass")
    }

    func testWhenFeatureABEnabledAndAssignmentIs50ThatInTestVariationDisabled() {
        let featureConfiguration =
        """
        [{
        "name": "Example Feature A/B Test",
        "enabled": true,
        "test-variations": ["Enabled", "Disabled"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 50.0
        XCTAssert(!feature.isTestVariation(.enabled), "Pass")
        XCTAssert(feature.isTestVariation(.disabled), "Pass")
    }

    func testWhenTestVariationAssignmentIsSmallAndNonZeroThatVariationIsGroupA() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [50, 50],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 0.0000000000000000000000000001
        XCTAssert(feature.isTestVariation(.groupA), "Pass")
        XCTAssert(!feature.isTestVariation(.groupB), "Pass")
    }

    func testWhenTestVariationAssignmentIsNinetyNineThatVariationIsGroupB() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [50, 50],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 99.99999999999999999999999999
        XCTAssert(!feature.isTestVariation(.groupA), "Pass")
        XCTAssert(feature.isTestVariation(.groupB), "Pass")
    }

    /// Test that when the test variation assignment is 100 that a group can still be assigned.
    /// This should never occur in practice as numbers are generated in the range [0.0, 100.0).
    func testWhenTestVariationAssignmentIsOneHundredThatVariationIsGroupB() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [50, 50],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 100.0
        XCTAssert(!feature.isTestVariation(.groupA), "Pass")
        XCTAssert(feature.isTestVariation(.groupB), "Pass")
    }

    func testWhenTestVariationAssignmentIs25VariationIsGroupA() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [50, 50],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 25.0
        XCTAssert(feature.isTestVariation(.groupA), "Pass")
        XCTAssert(!feature.isTestVariation(.groupB), "Pass")
    }

    func testWhenTestVariationAssignmentIs75VariationIsGroupB() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [50, 50],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 75.0
        XCTAssert(!feature.isTestVariation(.groupA), "Pass")
        XCTAssert(feature.isTestVariation(.groupB), "Pass")
    }

    func testWhenTestVariationAssignmentIs50VariationIsGroupB() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [50, 50],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 50.0
        XCTAssert(!feature.isTestVariation(.groupA), "Pass")
        XCTAssert(feature.isTestVariation(.groupB), "Pass")
    }

    func testWhenTestBiasIsZeroOneHundredThenVariationIsGroupB() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [0, 100],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            let feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        XCTAssert(!feature.isTestVariation(.groupA), "Pass")
        XCTAssert(feature.isTestVariation(.groupB), "Pass")
    }

    func testWhenTestBiasIsOneHundredZeroThenVariationIsGroupA() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-biases": [100, 0],
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            let feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        XCTAssert(feature.isTestVariation(.groupA), "Pass")
        XCTAssert(!feature.isTestVariation(.groupB), "Pass")
    }

    func testWhenTestVariationAssignmentIs33ThenVariationIsGroupA() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-variations": ["Group A", "Group B", "Group C"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 33.0
        XCTAssert(feature.isTestVariation(.groupA), "Pass")
        XCTAssert(!feature.isTestVariation(.groupB), "Pass")
        XCTAssert(!feature.isTestVariation(.groupC), "Pass")
    }

    func testWhenTestVariationAssignmentIs34ThenVariationIsGroupB() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-variations": ["Group A", "Group B", "Group C"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 34.0
        XCTAssert(!feature.isTestVariation(.groupA), "Pass")
        XCTAssert(feature.isTestVariation(.groupB), "Pass")
        XCTAssert(!feature.isTestVariation(.groupC), "Pass")
    }

    func testWhenTestVariationAssignmentIs66ThenVariationIsGroupB() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-variations": ["Group A", "Group B", "Group C"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 66.6
        XCTAssert(!feature.isTestVariation(.groupA), "Pass")
        XCTAssert(feature.isTestVariation(.groupB), "Pass")
        XCTAssert(!feature.isTestVariation(.groupC), "Pass")
    }

    func testWhenTestVariationAssignmentIs67ThenVariationIsGroupC() {
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-variations": ["Group A", "Group B", "Group C"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8),
            let features = try? decoder.decode([Feature].self, from: featuresData),
            var feature = features.first else {
                XCTAssert(false, "Fail")
                return
        }
        feature.testVariationAssignment = 66.7
        XCTAssert(!feature.isTestVariation(.groupA), "Pass")
        XCTAssert(!feature.isTestVariation(.groupB), "Pass")
        XCTAssert(feature.isTestVariation(.groupC), "Pass")
    }

    func testUsersDistributedEvenlyOverOneHundredThousandAttempts() {
        let percentageTolerance = 0.5
        let featureConfiguration =
        """
        [{
        "name": "Example A/B Test",
        "enabled": true,
        "test-variations": ["Group A", "Group B"]
        }]
        """
        let decoder = JSONDecoder()
        guard let featuresData = featureConfiguration.data(using: .utf8) else {
            XCTFail("Unable to decode feature data.")
            return
        }

        var groupACount = 0
        var groupBCount = 0
        for _ in 0..<100000 {
            guard let features = try? decoder.decode([Feature].self, from: featuresData),
            let feature = features.first else {
                XCTFail("Unable to decode feature data.")
                return
            }
            if feature.isTestVariation(.groupA) {
                groupACount += 1
            }
            if feature.isTestVariation(.groupB) {
                groupBCount += 1
            }
        }
        let totalTestCount = groupACount + groupBCount
        let percentageGroupA = Double(groupACount) / Double(totalTestCount) * 100.0
        let percentageGroupB = Double(groupBCount) / Double(totalTestCount) * 100.0
        if percentageGroupA > percentageGroupB {
            let percentageDifference = percentageGroupA - percentageGroupB
            XCTAssert(percentageDifference < percentageTolerance, "Users should be distributed equally into groups.")
        } else {
            let percentageDifference = percentageGroupB - percentageGroupA
            XCTAssert(percentageDifference < percentageTolerance, "Users should be distributed equally into groups.")
        }
    }

}

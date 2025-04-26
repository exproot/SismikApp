//
//  FetchNearbyEarthquakesUseCaseTests.swift
//  SismikAppTests
//
//  Created by Ertan Yağmur on 26.04.2025.
//

import XCTest
import Combine
@testable import SismikApp

final class FetchNearbyEarthquakesUseCaseTests: XCTestCase {

  var mockRepository: MockEarthquakeRepository!
  var useCase: DefaultFetchNearbyEarthquakesUseCase!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    mockRepository = MockEarthquakeRepository()
    useCase = DefaultFetchNearbyEarthquakesUseCase(repository: mockRepository)
    cancellables = []
  }

  func test_execute_success_returnsEarthquakes() {
    // Given
    mockRepository.resultToReturn = .success([
      Earthquake(
        id: "mockId",
        title: "Mock Earthquake",
        magnitude: 5.5,
        place: "Mock Place",
        time: Date(),
        latitude: 40.0,
        longitude: 20.0,
        depth: 10.0
      )
    ])

    let expectation = expectation(description: "Earthquakes loaded")

    // When
    useCase.execute(minLatitude: nil, maxLatitude: nil, minLongitude: nil, maxLongitude: nil)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { earthquakes in
          // Then
          XCTAssertEqual(earthquakes.count, 1)
          XCTAssertEqual(earthquakes.first?.title, "Mock Earthquake")
          XCTAssertEqual(earthquakes.first?.magnitude, 5.5)
          expectation.fulfill()
        }
      )
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 1.0)
  }

}

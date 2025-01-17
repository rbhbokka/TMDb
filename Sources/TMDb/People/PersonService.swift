import Foundation

///
/// Provides an interface for obtaining people from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class PersonService {

    private static let knownForShowsMaxCount = 10

    private let apiClient: APIClient

    ///
    /// Creates a person service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the primary information about a person.
    ///
    /// [TMDb API - People: Details](https://developer.themoviedb.org/reference/person-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person.
    /// 
    public func details(forPerson id: Person.ID) async throws -> Person {
        let person: Person
        do {
            person = try await apiClient.get(endpoint: PeopleEndpoint.details(personID: id))
        } catch let error {
            throw TMDbError(error: error)
        }

        return person
    }

    ///
    /// Returns the combined movie and TV series credits of a person.
    ///
    /// [TMDb API - People: Combined Credits](https://developer.themoviedb.org/reference/person-combined-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's combined movie and TV series credits.
    /// 
    public func combinedCredits(forPerson personID: Person.ID) async throws -> PersonCombinedCredits {
        let credits: PersonCombinedCredits
        do {
            credits = try await apiClient.get(endpoint: PeopleEndpoint.combinedCredits(personID: personID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the movie credits of a person.
    ///
    /// [TMDb API - People: Movie Credits](https://developer.themoviedb.org/reference/person-movie-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's movie credits.
    /// 
    public func movieCredits(forPerson personID: Person.ID) async throws -> PersonMovieCredits {
        let credits: PersonMovieCredits
        do {
            credits = try await apiClient.get(endpoint: PeopleEndpoint.movieCredits(personID: personID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the TV series credits of a person.
    ///
    /// [TMDb API - People: TV Credits](https://developer.themoviedb.org/reference/person-tv-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's TV series credits.
    /// 
    public func tvSeriesCredits(forPerson personID: Person.ID) async throws -> PersonTVSeriesCredits {
        let credits: PersonTVSeriesCredits
        do {
            credits = try await apiClient.get(endpoint: PeopleEndpoint.tvSeriesCredits(personID: personID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the images for a person.
    ///
    /// [TMDb API - People: Images](https://developer.themoviedb.org/reference/person-images)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's images.
    ///
    public func images(forPerson personID: Person.ID) async throws -> PersonImageCollection {
        let imageCollection: PersonImageCollection
        do {
            imageCollection = try await apiClient.get(endpoint: PeopleEndpoint.images(personID: personID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    ///
    /// Returns the list of known for shows for a person.
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's show credits.
    /// 
    public func knownFor(forPerson personID: Person.ID) async throws -> [Show] {
        let credits: PersonCombinedCredits
        do {
            credits = try await apiClient.get(endpoint: PeopleEndpoint.combinedCredits(personID: personID))
        } catch let error {
            throw TMDbError(error: error)
        }

        let topShowsSubSequence = credits.allShows.lazy
            .sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }
            .prefix(Self.knownForShowsMaxCount)
        let shows = Array(topShowsSubSequence)

        return shows
    }

    ///
    /// Returns the list of popular people.
    ///
    /// [TMDb API - People Lists: Popular](https://developer.themoviedb.org/reference/person-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular people as a pageable list.
    ///
    public func popular(page: Int? = nil) async throws -> PersonPageableList {
        let personList: PersonPageableList
        do {
            personList = try await apiClient.get(endpoint: PeopleEndpoint.popular(page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return personList
    }

}

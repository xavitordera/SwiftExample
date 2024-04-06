import Foundation

struct ArticleDataModel: Decodable, Equatable {
    let date: String
    let id: Int
    let summary: String
    let thumbnailTemplateUrl: String
    let thumbnailUrl: String
    let title: String
}

struct ArticleDetailsDataModel: Decodable, Equatable {
    let content: String
    let date: String
    let id: Int
    let imageUrl: String
    let sourceUrl: String
    let summary: String
    let thumbnailTemplateUrl: String
    let thumbnailUrl: String
    let title: String
}

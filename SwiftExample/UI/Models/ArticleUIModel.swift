import Foundation

struct ArticleUIModel: Identifiable {
    let title: String
    let summary: String
    let thumbnailURL: URL?
    let date: String
    let id: Int
}

extension ArticleUIModel: Equatable {
    init(_ article: ArticleDataModel) {
        self.title = article.title
        self.summary = article.summary
        self.thumbnailURL = URL(string: article.thumbnailUrl)
        self.date = article.date // here we could format the Date
        self.id = article.id
    }
}

struct ArticleDetailUIModel: Equatable {
    let content: String
    let date: String
    let id: Int
    let imageURL: URL?
    let title: String
}

extension ArticleDetailUIModel {
    init(_ article: ArticleDetailsDataModel) {
        self.content = article.content
        self.date = article.date
        self.id = article.id
        self.imageURL = URL(string: article.imageUrl)
        self.title = article.title
    }
}

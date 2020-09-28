public struct ToDo {
    var title: String
}

public enum DataSourceType {
    case MySql
    case MsSql
}

protocol DataSource {
    func getAll() -> [ToDo]
}

class MySql: DataSource {
    var login: String?
    var password: String?
    
    func getAll() -> [ToDo] {
        return [ToDo]()
    }
}

class MsSql: DataSource {
    func getAll() -> [ToDo] {
        return [ToDo]()
    }
}

class MySqlFabric {
    func create() -> DataSource {
        return MySql()
    }
}

class MsSqlFabric {
    func create() -> DataSource {
        return MsSql()
    }
}

public class DataSourceFabric: DataSource {
    let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    public func getAll() -> [ToDo] {
        return dataSource.getAll()
    }
    
    public static func create(type: DataSourceType) -> DataSourceFabric {
        switch type {
        case .MySql:
            return DataSourceFabric(dataSource: MySql())
        case .MsSql:
            return DataSourceFabric(dataSource: MsSql())
        }
    }
}

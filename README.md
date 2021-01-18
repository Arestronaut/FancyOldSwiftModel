# FancyOldSwiftModel

![Swift](https://github.com/Arestronaut/FancyOldSwiftModel/workflows/Swift/badge.svg)

... is a tool to generate swift models either by providing template files (which are written as a standalone swift protocol) or by using the inline sytnax

## Installation
For now building from source is the only available way to install the tool: 
1. Build swift package
```
swift build --configuration release
```

2. Copy the executable to `usr/local/bin`
```
cp -f .build/release/FancyOldSwiftModel /usr/local/bin/FancyOldSwiftModel
```

### TODO
- Add HomeBrew support

## Generate models from template files
In order to generate model from template files you need to provide a path to the templates and an output path.

`FancyOldSwiftModel generateFromTemplate -m #Output path# -t #Template path#`

By providing the flag `--creates` the given paths will be created if not existant.

### Example Template

A very simple example to create an Account type could look like this.

```swift
protocol AccountTemplate: Equatable, Codable {
    var id: UUID { get }
    var name: String { get set }
}
```

The result would be: 

```swift
struct Account: Equatable, Codable {
    let id: UUID
    var name: String
}
```

### Configure the output

Let's say you want a reference type instead of a value type and the type should be open: You simply add a configuration comment above the protocol declaration, like this: 

```swift
// modelgenconfig: refType, open
protocol AccountTemplate: Equatable, Codable {
    var id: UUID { get }
    var name: String { get set }
}
```

That would result in: 

```swift
open class Account: Equatable, Codable {
    public let id: UUID
    open var name: String

    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Equatable
extension Account {
    public static func ==(lhs: Account, rhs: Account) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
```

A full list of configurations can be found [here](https://github.com/Arestronaut/FancyOldSwiftModel/blob/main/Sources/FancyOldSwiftModel/Types/Config.swift).

### TODO
- Add support for more configurations

## Generate a model directly from the command line

Generating a simple model on the fly is pretty straight forward. Simply use the command `generate`: 

`FancyOldSwiftModel generate -i "Account" -m "id: UUID, name: String"`

That results in: 

```swift
struct Account {
    var id: UUID
    var name: String
}
```

The created file will be created in the current directory. Optionally an output path can be supplied with the argument `-o #Output path#`

### TODO
- Add support for configuration

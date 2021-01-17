import ArgumentParser
import Foundation

struct FancyOldSwiftModel: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "FancyOldSwiftModel",
        shouldDisplay: true,
        subcommands: [GenerateFromTemplate.self, Generate.self]
    )
}

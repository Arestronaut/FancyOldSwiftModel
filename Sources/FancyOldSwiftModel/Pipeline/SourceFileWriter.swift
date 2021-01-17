import Foundation

/// Writes the internal representation of a swift model to an actual usable swift model
final class SourceFileWriter: ChainedAsyncResultOperation<SwiftModel, Void, SourceFileWriter.Error> {
    enum Error: Swift.Error {
        case missingInput
        case clearingFile
        case writingToFile
    }

    private var modelsURL: URL

    init(modelsURL: URL) {
        self.modelsURL = modelsURL
    }

    override func main() {
        guard let input = input else { return finish(with: .failure(.missingInput)) }

        let modelFileName: String = input.identifier + Tokens.swiftFileExtensions

        let modelURL = modelsURL.appendingPathComponent(modelFileName)
        let fileManager: FileManager = .default
        if !fileManager.fileExists(atPath: modelURL.path) {
            fileManager.createFile(
                atPath: modelURL.path,
                contents: nil,
                attributes: nil
            )
        }

        // Clear file
        do {
            try String().write(to: modelURL, atomically: false, encoding: .utf8)
        } catch {
            return finish(with: .failure(.clearingFile))
        }

        self.write(line: input.swiftString, to: modelURL.path, isLastLine: true)

        return finish(with: .success(()))
    }

    private func write(line: String, to path: String, isLastLine: Bool = false) {
        do {
            if
                let fileHandle = FileHandle(forWritingAtPath: path),
                let data = line.data(using: .utf8)
            {
                try fileHandle.seekToEnd()

                fileHandle.write(data)

                if let newLine = Tokens.newLine.data(using: .utf8), !isLastLine {
                    fileHandle.write(newLine)
                }

                try fileHandle.close()
            }
        } catch {
            return finish(with: .failure(.writingToFile))
        }
    }
}



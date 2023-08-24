//
//  FeedScreenState.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 15.08.23.
//

struct FeedScreenState {

    var state = State.start
    var isDeleteActive = false

    var numberOfSections: Int {
        isDeleteActive ? 3 : 2
    }

    enum State {
        case start
        case loading
        case showing
    }

    enum TableSection {
        case feedsList
        case trashIcon
        case startScreen
        case loadingScreen
        case feedEntries

        init?(index: Int, state: State, isDeleteActive: Bool) {  // TODO: Rewrite.
            if isDeleteActive {
                switch index {
                case 0:
                    self = .feedsList
                case 1:
                    self = .trashIcon
                case 2:
                    switch state {
                    case .start:
                        self = .startScreen
                    case .loading:
                        self = .loadingScreen
                    case .showing:
                        self = .feedEntries
                    }
                default:
                    return nil
                }
            } else {
                switch index {
                case 0:
                    self = .feedsList
                case 1:
                    switch state {
                    case .start:
                        self = .startScreen
                    case .loading:
                        self = .loadingScreen
                    case .showing:
                        self = .feedEntries
                    }
                default:
                    return nil
                }
            }
        }
    }

}

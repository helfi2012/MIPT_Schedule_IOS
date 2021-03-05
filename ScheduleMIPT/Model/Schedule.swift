import SwiftUI

/**
 This class allows to store the whole schedule (from json file). It's stucture is equal to json file.
 */
class Schedule : Codable, ObservableObject {
    
    // Version of the schedule (is changing every semester)
    var version: String = "0.0"
    
    // Timetable is a representation of the json file (excluding version key)
    @Published var timetable = Dictionary<String, Array<ScheduleItem>>()
    
    /**
        This function allows to return sectioned schedule (divided by the days of the week)
        - Parameter groupNumber - name of the group
        - Returns array of `MenuSection`
     */
    func getSectionedMenu(groupNumber: String!) -> [MenuSection]! {
        if (groupNumber == nil) {
            return nil
        }
        var menu = [MenuSection]()
        let items = timetable[groupNumber]!
        let titles = StringUtils.getWeekLabels()
        for title in titles {
            menu.append(MenuSection(name: title))
        }
        for item in items {
            menu[item.day - 1].items.append(item)
        }
        for i in titles.indices {
            if (menu[i].items.count == 0) {
                menu[i].items.append(ScheduleItem())
            }
        }
        return menu
    }
    
    // Some shit to make Codable and @Published to work together
    enum CodingKeys: CodingKey {
        case timetable
        case version
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        timetable = try container.decode(Dictionary<String, Array<ScheduleItem>>.self, forKey: .timetable)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timetable, forKey: .timetable)
        try container.encode(version, forKey: .version)
    }
}

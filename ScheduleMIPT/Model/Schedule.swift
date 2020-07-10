import SwiftUI

class Schedule : Codable, ObservableObject {
    var version: String = ""
    @Published var timetable = Dictionary<String, Array<ScheduleItem>>()
    
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
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timetable = try container.decode(Dictionary<String, Array<ScheduleItem>>.self, forKey: .timetable)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timetable, forKey: .timetable)
    }
}

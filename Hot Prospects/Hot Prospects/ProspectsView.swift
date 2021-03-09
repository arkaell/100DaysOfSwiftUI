//
//  ProspectsView.swift
//  Hot Prospects
//
//  Created by David Liongson on 1/22/21.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var isShowingSortOptions = false
    @State private var sortOption = SortOption.recent
    
    enum SortOption {
        case name, recent
    }
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var sortedProspects: [Prospect] {
        switch sortOption {
        case .name:
            return filteredProspects.sorted(by: { $0.name < $1.name })
        case .recent:
            return filteredProspects.sorted(by: { $0.dateAdded < $1.dateAdded })
        }
    }
    
    private let firstNames = ["John", "Mary", "Michael", "Christina", "Steve", "Jennifer"]
    private let lastNames = ["Smith", "Brown", "Garcia", "Johnson", "Lee", "Miller"]
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        .contextMenu {
                            Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                                self.prospects.toggle(prospect)
                            }
                            
                            if !prospect.isContacted {
                                Button("Remind Me") {
                                    self.addNotification(for: prospect)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if filter == .none && !prospect.isContacted {
                            Image(systemName: "envelope.circle")
                        }
                    }
                }
            }
                .navigationBarTitle(title)
                .navigationBarItems(
                    leading: Button("Sort") {
                        self.isShowingSortOptions = true
                    },
                    trailing: Button(action: {
                        self.isShowingScanner = true
                    
                        }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr],
                                simulatedData: "\(firstNames.randomElement() ?? "David") \(lastNames.randomElement() ?? "Liongson")\nprospect\(Int.random(in: 1...99))@gmail.com",
                                completion: self.handleScan)
            }
            .actionSheet(isPresented: $isShowingSortOptions) {
                ActionSheet(title: Text("Sort by:"), buttons: [
                    .default(Text("By Name")) { self.sortOption = .name },
                    .default(Text("Most Recent")) { self.sortOption = .recent }
                ])
            }
        }
    }
    
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let prospect = Prospect()
            prospect.name = details[0]
            prospect.emailAddress = details[1]
            
            self.prospects.add(prospect)
            
        case .failure( _):
            print("Scanning Failed!")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //for testing purposes
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { (settings) in
            
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.badge, .alert, .sound]) { (success, error) in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}

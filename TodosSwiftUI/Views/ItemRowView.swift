//
//  ItemRowView.swift
//  TodosSwiftUI
//
//  Created by Arman Abkar on 6/19/21.
//

import SwiftUI

struct ItemRowView: View {
    
    var item:String = ""
    var dateCreated:Date = Date()
    var priority:String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(priority + " " + item)
                .font(.title2)
                .fontWeight(.semibold)
            Text("\(dateCreated)")
                .font(.body)
                .foregroundColor(.black.opacity(0.9))
                .lineLimit(3)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: "This is Test", dateCreated: Date(), priority: "🚨").previewLayout(.sizeThatFits)
    }
}

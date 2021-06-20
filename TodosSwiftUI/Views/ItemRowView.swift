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
        HStack{
            Text(priority)
                .font(.title3)
            
            VStack(alignment: .leading) {
                Text(item)
                    .font(.headline)
                
                Text("\(dateCreated)")
                    .font(.custom("Ariel", size: 10))
                    .lineLimit(3)
            }
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: "This is Test", dateCreated: Date(), priority: "🚨").previewLayout(.sizeThatFits)
    }
}

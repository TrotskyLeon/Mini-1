//
//  DateModifier.swift
//  Mini1
//
//  Created by Nadya Tyandra on 02/05/23.
//

import SwiftUI

struct FormattedDate: View {
    var date: String
    var body: some View {
        Text(date)
            .foregroundColor(Color.white)
            .font(.system(size: 32))
            .multilineTextAlignment(.leading)
            .padding(.top, 70)
            .padding(.leading, -10)
    }
}

struct FormattedTime: View {
    var time: Date
    var body: some View {
        Text(time.formatted(date: .omitted, time: .shortened))
            .foregroundColor(Color.white)
            .font(.system(size: 18))
            .multilineTextAlignment(.leading)
            .padding(.leading, 10)
    }
}

//
//  DateExt.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/8.
//

import Foundation
extension Date{
    func toYearMonthDayStr() -> String{
        let calendar = Calendar.current
        let tempYear = calendar.component(.year, from: self)
        let tempMonth = calendar.component(.month, from: self)
        let tmpDay = calendar.component(.day, from: self)
        let yaerStr = String(format: "%04d", tempYear)
        let monthStr = String(format: "%02d", tempMonth)
        let dayStr = String(format: "%02d", tmpDay)
        return "\(yaerStr)年\(monthStr)月\(dayStr)日"
    }
}

extension String {
    func toDate() -> Date? {
        let format:String = "yyyy年MM月dd日"
        let retDate: Date? = stringToDate(string: self, format: format)
        return retDate
    }
    
    func stringToDate(string:String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        guard let date = dateFormatter.date(from: string) else{
            return nil
        }
        return date
    }
}

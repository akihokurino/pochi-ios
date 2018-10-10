//
//  EditHostProfileData.swift
//  pochi
//
//  Created by akiho on 2017/02/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

struct EditSitterProfileData {
    enum TableSection: Int, EnumEnumerable {
        case profile
        case hostHouse
        case hostDog
        case service
    }
    
    let profile = InputCellData(
        label: "プロフィール",
        value: "",
        type: InputCellData.InputType.TextView,
        selectItems: nil)
    
    let keepableDogSize = InputCellData(
        label: "預かり可能な犬のサイズ",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["test1", "test2"])
    
    let houseType = InputCellData(
        label: "家のタイプ",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["test1", "test2"])
    
    let child = InputCellData(
        label: "子供",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["test1", "test2"])
    
    let isAvailableEarlyMorning = InputCellData(
        label: "朝早い時間の対応",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["可能", "不可能"])
    
    let isAvailableLateNight = InputCellData(
        label: "夜遅い時間の対応",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["可能", "不可能"])
    
    let isSmoking = InputCellData(
        label: "喫煙/禁煙の家",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["test1", "test2"])
    
    let dogPersonality = InputCellData(
        label: "飼い犬の性格",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    let keepStyle = InputCellData(
        label: "預かるスタイル",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["test1", "test2"])
    
    let takeWalk = InputCellData(
        label: "散歩について",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["test1", "test2"])
    
    let availableDogType = InputCellData(
        label: "世話が可能な犬のタイプ",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: ["test1", "test2"])
    
    let unavailableDog = InputCellData(
        label: "預かれない犬",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    static func getSectionCount() -> Int {
        return 4
    }

    func getSectionTitle(section: TableSection) -> String {
        switch section {
        case .profile:
            return "プロフィール文章"
        case .hostHouse:
            return "預かる家について"
        case .hostDog:
            return "飼い犬についての詳細"
        case .service:
            return "お世話の内容について"
        }
    }
    
    func getPropertiesForSection(section: TableSection) -> [InputCellData] {
        switch section {
        case .profile:
            return [profile]
        case .hostHouse:
            return [keepableDogSize, houseType, child, isAvailableEarlyMorning, isAvailableLateNight, isSmoking]
        case .hostDog:
            return [dogPersonality]
        case .service:
            return [keepStyle, takeWalk, availableDogType, unavailableDog]
        }
    }
}

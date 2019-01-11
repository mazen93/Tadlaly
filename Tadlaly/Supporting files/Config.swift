//
//  Config.swift
//  Tadlaly
//
//  Created by mahmoudhajar on 10/21/18.
//  Copyright © 2018 MahmoudHajar. All rights reserved.
//

import Foundation


class URLs {
    
    
    static let main = "http://tdlly.com/"
    
    
    static let image = main + "uploads/images/"
    
    static let urlShare = "https://itunes.apple.com/us/app/tadlly-%D8%AA%D8%AF%D9%84%D9%84%D9%8A/id1422871307?ls=1&mt=8"
    
    ///////////////////////////////////////////////
    
    
    //Registeration
    
    static let login =  main + "Api/Login"
    
    static let register = main + "Api/Registration"
    
                              
    static let resetPass = main + "Api/RestMyPass"
    
    //                          {user_id return from login }
    static let updatePass = main + "UpdatePass/"
    //                          {user_id return from login }
    static let logOut = main + "​Api/Logout/"
    
    //                          ​{user_id return from login }
    static let updateProfile = main + "Api/UpdateProfile/"
    //                          ​{user_id return from login }
    static let userTokenId = main + "user_token_id/"
    
    
    //////////////////////////////////////////////////
    
    
    //homeVC
    static let slidShow = main + "Api/SlidShow"
    
    static let categoryDep = main + "Api/ShowDepartment"
    
    
    
    //////////////////////////////////////////////////
    
    
    
    //SearchVC
    
    ///post{"main_department", "sub_department"}
    //static let farSearch = main + "Api/SearchFilter/1"
    
    /// post{"main_department" , "sub_department"}
   // static let nearSearch = main + "Api/SearchFilter/2"
    
   // static let nonUserNearSearch = main + "Api/Search/2"
    
    //static let nonUserFreshSearch = main + "Api/Search/1"
    
    static let searchTiltle = main + "Api/FindAdvertisement"
    
    
    
    ///////////////////////////////////////////////////
    
    //adsVC
    
    
    //                          {user_id return from login }/​{​sub_department​}
    
    
    
    //\(helper.getApiToken())
    static let SubNear = main + "Api/AllAdvertisement/2/18/"
    //                          {user_id return from login }​/​{​sub_department​}
    static let SubFresh = main + "Api/AllAdvertisement/1/"
    
    
    //                                    {​sub_department​}
    static let nonSubNear = main + "Api/DepAdvertisement/2/"
    //                                    {​sub_department​}
    static let nonUserFresh = main + "Api/DepAdvertisement/1/"
    
    
    //                       {user_id return from login }
    static let nearAds = main + "​Api/Advertisements/1/\(helper.getApiToken())"
    //                       {user_id return from login }
    static let freshAds = main+"​Api/Advertisements/2/"
    
    
    static let nonUserFreshAds = main + "Api/OurAdvertisements/1"
    static let nonUserNearAds = main + "Api/OurAdvertisements/2"
    
    
    
    ///////////////////////////////////////////////////
    
    // addAdvertiseVC
    //                       {user_id return from login }
    //\(helper.getApiToken())
    static let addAde = main + "Api/AddMyAdvertisement/18"
    
    
    
    ///////////////////////////////////////////////////
    
    
    //MyAdsVC
    
    //                                        {user_id}
    static let myRecAds = main + "Api/CurrentAdvertisement/"
    //                                        {user_id}
    static let myLastAds = main + "Api/OldAdvertisement/"
    
    //                                  { ​id_advertisement​ }
    static let updateMyAd = main + "​Api/UpdateAdvertisement/"
    
    static let deletMyAd = main + "Api/DeleteAdvertisement"
    
    ///////////////////////////////////////////////////////
    
    // message
    //                                        {user_id}
    static let sendMessage = main + "​Api/SendMessage/\(helper.getApiToken())"
    
    static let showCon = main + "Api/BetweenMessage/\(helper.getApiToken())/"
    
    //static let showAllMsgs = main + "Api/LastMessage/\(helper.getApiToken())"
    
    
    

    static let showAllMsgsUrl = main+"Api/LastMessage/\(helper.getApiToken())"
    static let deletAllMsgs = main + "Api/DeleteMessages"
    
    static let deletBetweenMessages = main + "Api/DeleteBetweenMessages​/\(helper.getApiToken())/"
    
    
    ///////////////////////////////////////////////////////////////////////
    
    
    ///Get request
    static let bank = main + "Api/BankAccounts"
    
    ///post{"name","email","subject","message"}
    static let  contactUs = main + "Api/ContactUs"
    
    /// Get request
    static let aboutUs = main + "Api/AboutUs"
    
    /// post        {user_id return from login }
    static let payment = main + "Api/Payment/\(helper.getApiToken())"
    
    static let rules = main + "Api/AppDetails/3"
    
    static let share = main + "Api/CountShare/"
    
    static let updateLoc = main + "Api/UpdateLocation"
    
    static let ekhaa = "http://www.ekhaa.org.sa"

    static let appShare = main + "Api/AppShare/​​\(helper.getApiToken())/ios"
    
   }



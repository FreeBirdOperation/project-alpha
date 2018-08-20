//
//  YelpV3Localization.swift
//  YAPI
//
//  Created by Daniel Seitz on 10/4/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

public typealias YelpLocaleProtocol = Language & Default

public struct LocaleParameter: Parameter {
  let internalValue: Language
  
  public var key: String = "locale"
  
  public var value: String {
    return internalValue.rawValue
  }
  
  public init(language value: Language) {
    self.internalValue = value
  }
}

public protocol Language {
  init?(rawValue: String)
  var rawValue: String { get }
}

public enum YelpLocale {
  public enum Czech : String, YelpLocaleProtocol {
    case czechRepublic = "cs_CZ"
    
    public static var defaultValue: Czech {
      return Czech.czechRepublic
    }
  }
  
  public enum Danish : String, YelpLocaleProtocol {
    case denmark = "da_DK"
    
    public static var defaultValue: Danish {
      return Danish.denmark
    }
  }
  
  public enum German : String, YelpLocaleProtocol {
    case austria = "de_AT"
    case switzerland = "de_CH"
    case germany = "de_DE"
    
    public static var defaultValue: German {
      return German.germany
    }
  }
  
  public enum English : String, YelpLocaleProtocol {
    case belgium = "en_BE"
    case canada = "en_CA"
    case switzerland = "en_CH"
    case unitedKingdom = "en_GB"
    case hongKong = "en_HK"
    case republicOfIreland = "en_IE"
    case malaysia = "en_MY"
    case newZealand = "en_NZ"
    case philippines = "en_PH"
    case singapore = "en_SG"
    case unitedStates = "en_US"
    
    public static var defaultValue: English {
      return English.unitedStates
    }
  }
  
  public enum Spanish : String, YelpLocaleProtocol {
    case argentina = "es_AR"
    case chile = "es_CL"
    case spain = "es_ES"
    case mexico = "es_MX"
    
    public static var defaultValue: Spanish {
      return Spanish.spain
    }
  }
  
  public enum Finnish : String, YelpLocaleProtocol {
    case finland = "fi_FI"
    
    public static var defaultValue: Finnish {
      return Finnish.finland
    }
  }
  
  public enum Filipino : String, YelpLocaleProtocol {
    case philippines = "fil_PH"
    
    public static var defaultValue: Filipino {
      return Filipino.philippines
    }
  }
  
  public enum French : String, YelpLocaleProtocol {
    case belgium = "fr_BE"
    case canada = "fr_CA"
    case switzerland = "fr_CH"
    case france = "fr_FR"
    
    public static var defaultValue: French {
      return French.france
    }
  }
  
  public enum Italian : String, YelpLocaleProtocol {
    case switzerland = "it_CH"
    case italy = "it_IT"
    
    public static var defaultValue: Italian {
      return Italian.italy
    }
  }
  
  public enum Japanese : String, YelpLocaleProtocol {
    case japan = "ja_JP"
    
    public static var defaultValue: Japanese {
      return Japanese.japan
    }
  }
  
  public enum Malay : String, YelpLocaleProtocol {
    case malaysia = "ms_MY"
    
    public static var defaultValue: Malay {
      return Malay.malaysia
    }
  }
  
  public enum Norwegian : String, YelpLocaleProtocol {
    case norway = "nb_NO"
    
    public static var defaultValue: Norwegian {
      return Norwegian.norway
    }
  }
  
  public enum Dutch : String, YelpLocaleProtocol {
    case belgium = "nl_BE"
    case theNetherlands = "nl_NL"
    
    public static var defaultValue: Dutch {
      return Dutch.theNetherlands
    }
  }
  
  public enum Polish : String, YelpLocaleProtocol {
    case poland = "pl_PL"
    
    public static var defaultValue: Polish {
      return Polish.poland
    }
  }
  
  public enum Portuguese : String, YelpLocaleProtocol {
    case brazil = "pt_BR"
    case portugal = "pt_PT"
    
    public static var defaultValue: Portuguese {
      return Portuguese.portugal
    }
  }
  
  public enum Swedish : String, YelpLocaleProtocol {
    case finland = "sv_FI"
    case sweden = "sv_SE"
    
    public static var defaultValue: Swedish {
      return Swedish.sweden
    }
  }
  
  public enum Turkish : String, YelpLocaleProtocol {
    case turkey = "tr_TR"
    
    public static var defaultValue: Turkish {
      return Turkish.turkey
    }
  }
  
  public enum Chinese : String, YelpLocaleProtocol {
    case hongKong = "zh_HK"
    case taiwan = "zh_TW"
    
    public static var defaultValue: Chinese {
      return Chinese.taiwan
    }
  }
}

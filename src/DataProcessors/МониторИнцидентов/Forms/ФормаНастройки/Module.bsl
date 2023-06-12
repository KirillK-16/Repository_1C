
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    НастройкиДиаграмм = ЭтотОбъект.Параметры.НастройкиДиаграмм;
    
    Для Каждого ТекНастройка Из НастройкиДиаграмм Цикл
        
        НовСтрока = ЭтотОбъект.ТипыДиаграмм.Добавить();
        НовСтрока.УровеньИнцидента = ТекНастройка.УровеньИнцидента;
        НовСтрока.ТипДиаграммы = ТекНастройка.ТипДиаграммы;
        
    КонецЦикла;
    
    ЭтотОбъект.ПериодОбновления = ЭтотОбъект.Параметры.ПериодОбновления;
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипыДиаграммТипДиаграммыПриИзменении(Элемент)
    
    ДанныеОповещения = Новый Соответствие;
    ДанныеОповещения.Вставить("ТекДанные", Элементы.ТипыДиаграмм.ТекущиеДанные);
        
    Оповестить("277004fa-403a-4a46-981d-13ce1d409048", ДанныеОповещения, ЭтотОбъект);
    
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбновленияПриИзменении(Элемент)
    
    ДанныеОповещения = Новый Соответствие;
    ДанныеОповещения.Вставить("ПериодОбновления", ЭтотОбъект.ПериодОбновления);
        
    Оповестить("277004fa-403a-4a46-981d-13ce1d409048", ДанныеОповещения, ЭтотОбъект);
    
КонецПроцедуры

#КонецОбласти
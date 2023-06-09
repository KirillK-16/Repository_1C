
#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
    ПодключитьОбработчикОжидания("ОбновитьДанныеПодключаемый", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДанныеПодключаемый() Экспорт
    
    ТекДанные = Элементы.Список.ТекущиеДанные;
    
    Если ТекДанные <> Неопределено Тогда
        ЭтотОбъект.Данные = ФорматироватьJson(ТекДанные.Данные);
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Функция ФорматироватьJson(Строка)
    
    #Если ВебКлиент Тогда
        Возврат ФорматироватьJsonНаСервере(Строка); 
    #Иначе
        Возврат ФорматироватьJsonНаКлиенте(Строка); 
    #КонецЕсли
    
КонецФункции

&НаКлиенте
Функция ФорматироватьJsonНаКлиенте(Строка)
    
    #Если ТонкийКлиент Тогда
        
        ЧтениеJSON = Новый ЧтениеJSON();
        ЧтениеJSON.УстановитьСтроку(Строка);
        
        Объект = ПрочитатьJSON(ЧтениеJSON, Истина);
        
        ЗаписьJSON = Новый ЗаписьJSON();
        ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, "    "));
        ЗаписатьJSON(ЗаписьJSON, Объект);
        
        Возврат ЗаписьJSON.Закрыть();
        
    #КонецЕсли
    
КонецФункции

&НаСервереБезКонтекста
Функция ФорматироватьJsonНаСервере(Строка)
    
    ЧтениеJSON = Новый ЧтениеJSON();
    ЧтениеJSON.УстановитьСтроку(Строка);
    
    Объект = ПрочитатьJSON(ЧтениеJSON, Истина);
    
    ЗаписьJSON = Новый ЗаписьJSON();
    ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, "    "));
    ЗаписатьJSON(ЗаписьJSON, Объект);
    
    Возврат ЗаписьJSON.Закрыть();
    
КонецФункции

#КонецОбласти

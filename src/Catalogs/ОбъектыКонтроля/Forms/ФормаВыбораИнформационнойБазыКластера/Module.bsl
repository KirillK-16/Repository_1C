
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    Если ЭтотОбъект.Параметры.Отбор.Свойство("Кластер") Тогда
        ЭтотОбъект.Заголовок = "Информационные базы кластера """ + ЭтотОбъект.Параметры.Отбор.Кластер + """.";
    КонецЕсли;
КонецПроцедуры

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьДокументРегистратор(Дата) Экспорт
    
    Запрос = Новый Запрос;
    
    Запрос.Текст = "ВЫБРАТЬ
                   |	РегистраторДанныхИнформационнойБазы.Ссылка КАК Ссылка
                   |ИЗ
                   |	Документ.РегистраторДанныхИнформационнойБазы КАК РегистраторДанныхИнформационнойБазы
                   |ГДЕ
                   |	РегистраторДанныхИнформационнойБазы.Дата = &Дата";
    
    Запрос.УстановитьПараметр("Дата", Дата);
       
    Результат = Запрос.Выполнить();
    Если НЕ Результат.Пустой() Тогда
        Выборка = Результат.Выбрать();
        Выборка.Следующий();
        ДокументАгрегатаСсылка = Выборка.Ссылка; 
    Иначе
        ДокументАгрегатаСсылка = Документы.РегистраторДанныхИнформационнойБазы.ПустаяСсылка();
    КонецЕсли;
    
    Возврат ДокументАгрегатаСсылка;
        
КонецФункции

#КонецОбласти

#КонецЕсли
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПрограммныйИнтерфейс

Функция ТекущийПроцентДоступности(Ресурс, ПериодКонтроля) Экспорт
    
    ТекДата = ТекущаяДата();
    
    ДатаНачала = ТекДата - ПериодКонтроля;
    ДатаОкончания = ТекДата;
    
    Запрос = Новый Запрос;
    Запрос.Текст = "
    |ВЫБРАТЬ
    |   ISNULL(МИНИМУМ(Период), &ПустаяДата) КАК Период
    |ИЗ
    |   РегистрСведений.ДоступностьСайта КАК ДоступностьСайта
    |ГДЕ
    |   ДоступностьСайта.Ресурс = &Ресурс
    |";
    
    Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));
    Запрос.УстановитьПараметр("Ресурс", Ресурс);
    
    Результат = Запрос.Выполнить();
    
    ТекущийПроцентДоступности = -1;
    
    Если НЕ Результат.Пустой() Тогда
        
        Выборка = Результат.Выбрать();
        Выборка.Следующий();
        Если Выборка.Период > ДатаНачала Тогда
            ДатаНачала = Выборка.Период;
        КонецЕсли;
                
        ТекстЗапросаПериодов = Общий.ТекстЗапросаПериодов(ДатаНачала, ДатаОкончания, "Секунда");
        
        Запрос.Текст = ТекстЗапросаПериодов + "
        |;
        |ВЫБРАТЬ
        |   МАКСИМУМ(Период) КАК Период
        |ПОМЕСТИТЬ
        |	ПредыдущаяЗапись
        |ИЗ
        |    РегистрСведений.ДоступностьСайта КАК ДоступностьСайта
        |ГДЕ
        |    ДоступностьСайта.Ресурс = &Ресурс
        |    И ДоступностьСайта.Период <= &ДатаНачала
        |;
        |ВЫБРАТЬ
        |	&ДатаНачала КАК Период,
        |	ВЫБОР 
        |      КОГДА ДоступностьСайта.Доступность = 1 Тогда 1
        |      КОГДА ДоступностьСайта.Доступность = 0 Тогда -1
        |   КОНЕЦ КАК Результат
        |ПОМЕСТИТЬ
        |	ПредыдущийРезультат
        |ИЗ
        |	ПредыдущаяЗапись КАК ПредыдущаяЗапись
        |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
        |   РегистрСведений.ДоступностьСайта КАК ДоступностьСайта
        |ПО
        |   ДоступностьСайта.Ресурс = &Ресурс
        |   И ДоступностьСайта.Период = ПредыдущаяЗапись.Период
        |;
        |ВЫБРАТЬ
        |   Периоды.Период,
        |   ВЫБОР 
        |      КОГДА ЕстьNULL(ДоступностьСайта.Период, 0)  = 0 ТОГДА 0
        |      КОГДА ДоступностьСайта.Доступность = 1 Тогда 1
        |      КОГДА ДоступностьСайта.Доступность = 0 Тогда -1
        |   КОНЕЦ КАК Результат
        |ПОМЕСТИТЬ
        |	ТекущийРезультат
        |ИЗ
        |   Периоды КАК Периоды
        |ЛЕВОЕ СОЕДИНЕНИЕ
        |   РегистрСведений.ДоступностьСайта КАК ДоступностьСайта
        |ПО
        |   ДоступностьСайта.Период = Периоды.Период
        |   И ДоступностьСайта.Ресурс = &Ресурс
        |;
        |ВЫБРАТЬ
        |	Период,
        |	Результат
        |ИЗ
        |	ПредыдущийРезультат
        |	
        |ОБЪЕДИНИТЬ
        |
        |ВЫБРАТЬ
        |	Период,
        |	Результат
        |ИЗ
        |	ТекущийРезультат
        |ГДЕ
        |   Период <> &ДатаНачала 
        |УПОРЯДОЧИТЬ ПО
        |	Период
        |";
        
        Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
        Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
        Запрос.УстановитьПараметр("Ресурс", Ресурс);    
        
        Результат = Запрос.Выполнить();
        
        ТаблицаПодключений = Результат.Выгрузить();
        
        ПредыдущийРезультатПодключения = Неопределено;
        КоличествоУспешно = 0;
        Для Каждого ТекРезультат Из ТаблицаПодключений Цикл
            
            Если ТекРезультат.Результат = 1 Тогда
                
                КоличествоУспешно = КоличествоУспешно + 1;
                ПредыдущийРезультатПодключения = ТекРезультат.Результат;
                
            ИначеЕсли ТекРезультат.Результат = 0 И ПредыдущийРезультатПодключения = 1 Тогда
                
                КоличествоУспешно = КоличествоУспешно + 1;
                
            ИначеЕсли ТекРезультат.Результат = -1 Тогда
                
                ПредыдущийРезультатПодключения = ТекРезультат.Результат;
                
            КонецЕсли;
            
        КонецЦикла;
        
        ТекущийПроцентДоступности = ОКР((КоличествоУспешно/ТаблицаПодключений.Количество()) * 100, 2);
        
    КонецЕсли;
    
    Возврат ТекущийПроцентДоступности;
    
КонецФункции

#КонецОбласти
    
#КонецЕсли

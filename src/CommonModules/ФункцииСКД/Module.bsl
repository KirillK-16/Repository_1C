#Область ПрограммныйИнтерфейс

Функция ФорматированиеДаты(Дата, Парам, КонецПериода) Экспорт
	Если Парам = "Час" Тогда
		Возврат Формат(Дата, "ДФ='ЧЧ''ч 00м " + Символы.ПС + "''дд.ММ.гг'");
	ИначеЕсли Парам = "День" Тогда
		Возврат Формат(Дата, "ДФ=дд.ММ.гг");
	ИначеЕсли Парам = "Неделя" Тогда
		ДатаКонцаНедели = КонецНедели(Дата);
		Если ДатаКонцаНедели > КонецПериода Тогда
			ДатаКонцаНедели = КонецПериода;
		КонецЕсли;
		Возврат Формат(Дата, "ДФ=дд.ММ.гг") + " - " + Формат(ДатаКонцаНедели, "ДФ=дд.ММ.гг");
	КонецЕсли;
КонецФункции

Функция ФорматироватьСекунды(Знач Секунды) Экспорт
    
    Если ТипЗнч(Секунды) <> Тип("Число") Тогда
        Возврат "";
    КонецЕсли;
        
    Если Секунды < 60 Тогда
        Возврат Формат(Секунды, "ЧЦ=2; ЧВН=") + "сек";
    ИначеЕсли Секунды < 3600 Тогда
        Возврат Формат(ЦЕЛ(Секунды/60), "ЧЦ=2; ЧВН=") + "мин " + Формат(Секунды%60, "ЧЦ=2; ЧВН=") + "сек";
    Иначе
        Часов = ЦЕЛ(Секунды/3600);
        Секунды = Секунды - Часов * 3600;
        Возврат Формат(Часов, "ЧДЦ=" + "ч ") + "ч " + Формат(ЦЕЛ(Секунды/60), "ЧЦ=2; ЧВН=") + "мин " + Формат(Секунды%60, "ЧЦ=2; ЧВН=") + "сек";
    КонецЕсли;
    
КонецФункции

Функция СформироватьПрограммноНаСервере(СхемаКомпоновкиДанных, Настройки, УникальныйИдентификатор, АдресХранилища) Экспорт
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровкиОбъект = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПКД = Новый ПроцессорКомпоновкиДанных;
	ПКД.Инициализировать(МакетКомпоновки,,ДанныеРасшифровки, Истина);
	ПВ = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	
	Результат = Новый ТабличныйДокумент;
	
	ПВ.УстановитьДокумент(Результат);
	ПВ.Вывести(ПКД);
	
	Если Результат.Рисунки.Количество() = 1 Тогда
		Результат.Рисунки[0].Объект.Обновление = Ложь;
		
		Если МакетКомпоновки.ЗначенияПараметров.ПереодичностьЗамеров.Значение <> "Весь период" Тогда
			ДобавитьПустыеПериоды(Результат.Рисунки[0].Объект, МакетКомпоновки);
			
			
			Результат.Рисунки[0].Объект.ОбластьПостроения.Лево = 0;
			Результат.Рисунки[0].Высота = 60;
			Результат.Рисунки[0].Ширина = 300;
			Результат.Рисунки[0].Объект.Обновление = Истина;
			
			Результат.Рисунки[0].Объект.ОбластьПостроения.ОриентацияМеток = ОриентацияМетокДиаграммы.Горизонтально;
			Для Каждого ТекСерия Из Результат.Рисунки[0].Объект.Серии Цикл
				ТекСерия.Маркер = ТипМаркераДиаграммы.Нет;
			КонецЦикла;
			Результат.Область("R20:R35").ВысотаСтроки = 1;
		Иначе
			Результат.Рисунки.Удалить(Результат.Рисунки[0]);
			Результат.Область("R9:R35").АвтоВысотаСтроки = Ложь;
			Результат.Область("R9:R35").ВысотаСтроки = 1;
		КонецЕсли;
	КонецЕсли;
	
	Результат.ПоказатьУровеньГруппировокСтрок(1);
	Результат.ПоказатьУровеньГруппировокСтрок(0);
		
	ДанныеФЗ = Новый Структура;
	ДанныеФЗ.Вставить("ТабличныйДокумент", Результат);
	ДанныеФЗ.Вставить("ДанныеРасшифровки", ДанныеРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеФЗ, АдресХранилища);
КонецФункции

Процедура ДобавитьПустыеПериоды(Диаграмма, МакетКомпоновки)
	Период = МакетКомпоновки.ЗначенияПараметров.Период.Значение;
	ПериодичностьЗамеров = МакетКомпоновки.ЗначенияПараметров.ПереодичностьЗамеров.Значение;
	
	Если ПериодичностьЗамеров = "Час" Тогда
		ПериодичностьЗамеровЧисло = 3600;
		ФорматДаты = "ДФ='дд.ММ.гг ЧЧ:мм'";
		ДатаНачала = Период.ДатаНачала;
	ИначеЕсли ПериодичностьЗамеров = "День" Тогда
		ПериодичностьЗамеровЧисло = 86400;
		ФорматДаты = "ДФ='дд.ММ.гг'";
		ДатаНачала = Период.ДатаНачала;
	ИначеЕсли ПериодичностьЗамеров = "Неделя" Тогда
		ПериодичностьЗамеровЧисло = 604800;
		ФорматДаты = "ДФ='дд.ММ.гг'";
		ДатаНачала = НачалоНедели(Период.ДатаНачала);
	КонецЕсли;
	
	ДанныеДиаграммы = Новый Соответствие;
	СерииДиаграммыБуфер = Новый Соответствие;
	Для Каждого ТекТочка Из Диаграмма.Точки Цикл
		ТекстТочкиМассив = СтрРазделить(ТекТочка.Текст, " ", Ложь);
		ТекстТочкиМассивВремя = СтрРазделить(ТекстТочкиМассив[1], ":", Ложь);
		
		ТекстТочкиМассив = СтрРазделить(ТекстТочкиМассив[0], ".", Ложь);
		ТекстТочкиМассив[2] = "20" + ТекстТочкиМассив[2];
		
		ДатаТочки = Дата(ТекстТочкиМассив[2] + ТекстТочкиМассив[1] + ТекстТочкиМассив[0] + ТекстТочкиМассивВремя[0] + ТекстТочкиМассивВремя[1]);
		
		ДанныеДиаграммы.Вставить(ДатаТочки, Новый Соответствие);
		Для Каждого ТекСерия Из Диаграмма.Серии Цикл
			ДанныеДиаграммы[ДатаТочки].Вставить(ТекСерия.Текст, Диаграмма.ПолучитьЗначение(ТекТочка, ТекСерия).Значение);
			СерииДиаграммыБуфер.Вставить(ТекСерия.Текст, Неопределено);
		КонецЦикла;
	КонецЦикла;
	
	Диаграмма.Очистить();
	
	Для Каждого ТекСерия Из СерииДиаграммыБуфер Цикл
		Серия = Диаграмма.УстановитьСерию(ТекСерия.Ключ);
		Серия.Текст = ТекСерия.Ключ;
		СерииДиаграммыБуфер[ТекСерия.Ключ] = Серия;
	КонецЦикла;
	
	Пока ДатаНачала <= Период.ДатаОкончания Цикл
		Точка = Диаграмма.УстановитьТочку(ДатаНачала);
		Точка.Текст = Формат(ДатаНачала, ФорматДаты);
		
		ДанныеБуфер = ДанныеДиаграммы[ДатаНачала];
		Если ДанныеБуфер = Неопределено Тогда
			Для Каждого ТекСерия Из СерииДиаграммыБуфер Цикл
				Диаграмма.УстановитьЗначение(Точка, ТекСерия.Значение, -0.00001,, "Нет данных");
			КонецЦикла;
		Иначе
			Для Каждого ТекДанные Из ДанныеБуфер Цикл
				Подсказка = "APDEX " + Формат(ТекДанные.Значение, "ЧДЦ=3; ЧН=0,000") + "
				|" + Точка.Текст + "
				|" + СерииДиаграммыБуфер[ТекДанные.Ключ].Текст;
				Диаграмма.УстановитьЗначение(Точка, СерииДиаграммыБуфер[ТекДанные.Ключ], ТекДанные.Значение,,Подсказка); 
			КонецЦикла;
		КонецЕсли;
		
		ДатаНачала = ДатаНачала + ПериодичностьЗамеровЧисло;
	КонецЦикла;
	
КонецПроцедуры

Функция ВычислитьSQRT(Значение) Экспорт
	Если ЗначениеЗаполнено(Значение) Тогда
		Возврат SQRT(Значение);
	КонецЕсли;
КонецФункции

Функция ВычислитьЦЕЛ(Значение) Экспорт
	Возврат ЦЕЛ(Значение);
КонецФункции

Функция СкомпоноватьРезультатВФоне(ИмяОтчета, АдресХранилища) Экспорт
    
    Результат = Новый ТабличныйДокумент;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	Отчет = Отчеты[ИмяОтчета].Создать();	
	Отчет.СкомпоноватьРезультат(Результат, ДанныеРасшифровки);
	
	РезультатКомпоновки = Новый Структура;
	РезультатКомпоновки.Вставить("Результат", Результат);
	РезультатКомпоновки.Вставить("РезультатДиаграмма", Отчет.РезультатДиаграмма);
	РезультатКомпоновки.Вставить("ДанныеРасшифровки", ДанныеРасшифровки);
	
	ПоместитьВоВременноеХранилище(РезультатКомпоновки, АдресХранилища);
    
КонецФункции

Функция ПриКомпоновкеРезультатаФоновоеЗадание(Параметры) Экспорт
    
    АдресХранилища = Параметры.АдресХранилища;
    ДокументРезультат = Параметры.ДокументРезультат;
    ДанныеРасшифровки = Параметры.ДанныеРасшифровки;
    Настройки = Параметры.Настройки;
    ПользовательскиеНастройки = Параметры.ПользовательскиеНастройки;
    ИмяОтчета = Параметры.ИмяОтчета;
    ИмяСхемыКомпоновки = Параметры.ИмяСхемыКомпоновки;
    ИмяНаборДанных = Параметры.ИмяНаборДанных;
        
    ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;				// Создаем данные расшифровки 
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;				// Создаем компоновщик макета 
    
    Отчет = Отчеты[ИмяОтчета].Создать();
    Результат = Отчет.ПолучитьДанныеДляВывода(Настройки, ПользовательскиеНастройки);
    
    Если Результат <> Неопределено Тогда
           
        // Инициализируем макет компоновки используя схему компоновки данных 
        СхемаКомпоновкиДанных = Отчеты[ИмяОтчета].ПолучитьМакет(ИмяСхемыКомпоновки);
        МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
        
        // Скомпонуем результат
        ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
        ПараметрыПроцессораКомпоновки = Новый Структура(ИмяНаборДанных, Результат);
        ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ПараметрыПроцессораКомпоновки, ДанныеРасшифровки);
        
        ДокументРезультат.Очистить();
        
        // Выводим результат в табличный документ
        ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
        ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
        ПроцессорВывода.Вывести(ПроцессорКомпоновки);
        
        РезультатВХранилище = Новый Структура;
        РезультатВХранилище.Вставить("ДокументРезультат", ДокументРезультат);
        РезультатВХранилище.Вставить("ДанныеРасшифровки", ДанныеРасшифровки);
        
        ПоместитьВоВременноеХранилище(РезультатВХранилище, АдресХранилища);
        
    КонецЕсли;
    
КонецФункции

Функция ПолучитьТаблицуЗначенийЭлементаДинамическогоСписка(Список, ДополнительныеПоля = Неопределено) Экспорт
 
	Схема = Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
    
    Если ДополнительныеПоля <> Неопределено Тогда
        ДетальныеЗаписи = Настройки.Структура[0];
        Пока ДетальныеЗаписи.Структура.Количество() > 0 Цикл
            ДетальныеЗаписи = ДетальныеЗаписи.Структура[0];
        КонецЦикла;
        Для Каждого ТекПоле Из ДополнительныеПоля Цикл
            НовПоле = ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
            НовПоле.Поле = Новый ПолеКомпоновкиДанных(ТекПоле);
            НовПоле.Использование = Истина;
        КонецЦикла;
    КонецЕсли;
    
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
 
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Данные = Новый ТаблицаЗначений;
    
	ПроцессорВывода.УстановитьОбъект(Данные); 
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
    
    Возврат Данные;
 
КонецФункции

Функция ЗначениеВXML(Значение) Экспорт
    
    Поток = Новый ЗаписьXML();
    Поток.УстановитьСтроку();
    СериализаторXDTO.ЗаписатьXML(Поток, Значение);
    
    Возврат Поток.Закрыть();
        
КонецФункции

Функция ПолучитьТаблицуЗначенийДинамическогоСписка(ДинамическийСписок, ИменаПолей) Экспорт
 
    СКД = Новый СхемаКомпоновкиДанных;
    Источник = СКД.ИсточникиДанных.Добавить();
    Источник.Имя = "ЛокальнаяБаза";
    Источник.СтрокаСоединения     = "";
    Источник.ТипИсточникаДанных = "Local";
 
    НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
    НаборДанных.Имя = "Основной";
    НаборДанных.ИсточникДанных = "ЛокальнаяБаза";
    НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
    НаборДанных.Запрос = ДинамическийСписок.ТекстЗапроса;
    ТекстЗапроса = ДинамическийСписок.ТекстЗапроса;
    СКД.НаборыДанных.Основной.Запрос = ТекстЗапроса;
    
    МассивПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаПолей);
    Для каждого Поле Из МассивПолей Цикл
        ПолеСКД = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
        ПолеСКД.Заголовок = Поле;
        ПолеСКД.ПутьКДанным = Поле;
        ПолеСКД.Поле = Поле;
    КонецЦикла;
    
     НастройкиКомпоновкиДанных = СКД.НастройкиПоУмолчанию;
     
    ГруппировкаДетальная = НастройкиКомпоновкиДанных.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
    Для каждого Поле Из МассивПолей Цикл
        ВыбранноеПоле = ГруппировкаДетальная.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
        ВыбранноеПоле.Заголовок = Поле;
        ВыбранноеПоле.Использование = Истина;
        ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(Поле);
    КонецЦикла; 
    
    Результат = Новый ТаблицаЗначений;    
    ПроцессорВыводаВТЗ = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;    
    ПроцессорВыводаВТЗ.УстановитьОбъект(Результат);    
    
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
    КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
    КомпоновщикНастроек.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
    
    Для Каждого ЭлементОтбораДС Из ДинамическийСписок.Отбор.Элементы Цикл
        
        Если ТипЗнч(ЭлементОтбораДС) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
            ГруппаОтбораСКД = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
            Для Каждого ЭлементОтбораГруппы Из ЭлементОтбораДС.Элементы Цикл
                ЭлементОтбораСКД = ГруппаОтбораСКД.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
                ЗаполнитьЗначенияСвойств(ЭлементОтбораСКД, ЭлементОтбораДС.Элементы);
            КонецЦикла;
        Иначе
            ЭлементОтбораСКД = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
            ЗаполнитьЗначенияСвойств(ЭлементОтбораСКД, ЭлементОтбораДС);
        КонецЕсли;
        
    КонецЦикла;    
    
    Для Каждого ЗначениеПараметраДС Из ДинамическийСписок.Параметры.Элементы Цикл
        ЗначениеПараметраСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Добавить();
        ЗаполнитьЗначенияСвойств(ЗначениеПараметраСКД, ЗначениеПараметраДС);
    КонецЦикла;
    
    МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД,КомпоновщикНастроек.Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
    
    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;    
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
    
    Результат = ПроцессорВыводаВТЗ.Вывести(ПроцессорКомпоновкиДанных);    
    
    Возврат Результат;
	
КонецФункции

Функция НайтиЭлементПользовательскойНастройки(ГруппаНастроек, Настройки, ПараметрНастроек) Экспорт
    
    Элемент = Неопределено;
    
    Для Каждого ТекЭлемент Из ГруппаНастроек.ПодчиненныеЭлементы Цикл
        Если ТипЗнч(ТекЭлемент) = Тип("ГруппаФормы") Тогда
            Элемент = НайтиЭлементПользовательскойНастройки(ТекЭлемент, Настройки, ПараметрНастроек);
            Если ТипЗнч(Элемент) = Тип("ПолеФормы") Тогда
                Возврат Элемент;
            КонецЕсли;
        ИначеЕсли ТипЗнч(ТекЭлемент) = Тип("ПолеФормы") И ТекЭлемент.Вид = ВидПоляФормы.ПолеВвода Тогда
            Если СтрНайти(ТекЭлемент.ПутьКДанным, "КомпоновщикНастроек.ПользовательскиеНастройки") > 0 Тогда
                
                ИндексСлева = СтрНайти(ТекЭлемент.ПутьКДанным, "[");
                ИндексСправа = СтрНайти(ТекЭлемент.ПутьКДанным, "]", НаправлениеПоиска.СНачала, ИндексСлева);
                
                ИндексНастройки = Число(Сред(ТекЭлемент.ПутьКДанным, ИндексСлева + 1, ИндексСправа - ИндексСлева - 1));
                
                Если ТипЗнч(Настройки.Элементы[ИндексНастройки]) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
                    Если Настройки.Элементы[ИндексНастройки].Параметр = ПараметрНастроек Тогда
                        Возврат ТекЭлемент;
                    КонецЕсли;
                КонецЕсли;
                                
            КонецЕсли;            
        КонецЕсли;
    КонецЦикла;
    
    Возврат Элемент;
    
КонецФункции

Функция ЗначениеПараметраОтчета(ИмяОтчета, Параметр) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	НастройкиОтчетовСКД.Значение КАК Значение
	                      |ИЗ
	                      |	РегистрСведений.НастройкиОтчетовСКД КАК НастройкиОтчетовСКД
	                      |ГДЕ
	                      |	НастройкиОтчетовСКД.ИмяОтчета = &ИмяОтчета
	                      |	И НастройкиОтчетовСКД.ИмяПараметра = &Параметр");
	Запрос.УстановитьПараметр("ИмяОтчета",ИмяОтчета);
	Запрос.УстановитьПараметр("Параметр",Параметр);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗначениеХранилища = Выборка.Значение.Получить();
		Если ТипЗнч(ЗначениеХранилища) = Тип("Массив") Тогда
			Возврат ЗначениеХранилища;
		Иначе
			Возврат Новый Массив;
		КонецЕсли;
	Иначе
		Возврат Новый Массив;
	КонецЕсли;
КонецФункции

// Функция - Инициализировать компоновщик
//
// Параметры:
//  Компоновщик      - КомпоновщикНастроекКомпоновкиДанных    - Компоновщик настроек компоновки данных для инициализации.
//  ПоляНабораДанных - Массив - Массив структур с:
//                                  Обязательными ключами: "Поле", "Заголовок", "ОписаниеТипов".
//                                  Не обязательные ключи: "ОграничениеИспользованияРеквизитовУсловие", "ТипУпорядочивания".
// 
Процедура ИнициализироватьКомпоновщик(Компоновщик, ПоляНабораДанных) Экспорт
    
    СКД = Новый СхемаКомпоновкиДанных();
	ИсточникСКД = СКД.ИсточникиДанных.Добавить();
	ИсточникСКД.Имя = "ИсточникДанных1";
	ИсточникСКД.ТипИсточникаДанных = "local";
    
    НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
    НаборДанных.ИсточникДанных = ИсточникСКД.Имя;
    НаборДанных.Имя = "НаборДанных1";
    НаборДанных.ИмяОбъекта = "НаборДанных1";
    
    Для Каждого ПолеНабораДанных Из ПоляНабораДанных Цикл
        ДобавитьПолеВНаборДанных(Компоновщик, НаборДанных, ПолеНабораДанных);
    КонецЦикла;
    
    URLСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
    Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
    
    ГруппировкаКомпоновкиДанных = Компоновщик.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
    
    Для Каждого ПолеНабораДанных Из ПоляНабораДанных Цикл
        ДобавитьПолеВГруппировкуДанных(ГруппировкаКомпоновкиДанных, Компоновщик, ПолеНабораДанных);
    КонецЦикла;
                
КонецПроцедуры

// Процедура - Установить отбор таблицы значений
//
// Параметры:
//  ТаблицаЗначенийИсточник   - ТаблицаЗначений - Таблица значений с данными.
//  ТаблицаЗначенийПолучатель - ТаблицаЗначений - Таблица значений данных, полученных с применением отбора.
//  Компоновщик  - КомпоновщикНастроекКомпоновкиДанных - Инициализированный компоновщик настроек компоновки данных, см. описание "ФункцииСКД.ИнициализироватьКомпоновщик".
//
Процедура УстановитьОтборТаблицыЗначений(ТаблицаЗначенийИсточник, ТаблицаЗначенийПолучатель, Компоновщик) Экспорт
    
    ТаблицаЗначенийБуфер = Новый ТаблицаЗначений;
    
    СКД = Новый СхемаКомпоновкиДанных();
    ИсточникСКД = СКД.ИсточникиДанных.Добавить();
    ИсточникСКД.Имя = "ИсточникДанных1";
    ИсточникСКД.ТипИсточникаДанных = "local";
    
    НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
    НаборДанных.ИсточникДанных = ИсточникСКД.Имя;
    НаборДанных.Имя = "НаборДанных1";
    НаборДанных.ИмяОбъекта = "НаборДанных1";
    
    Для Каждого Колонка Из ТаблицаЗначенийИсточник.Колонки Цикл
        Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
        Поле.Поле = Колонка.Имя;
        Поле.ПутьКДанным = Колонка.Имя;
        Поле.Заголовок = Колонка.Заголовок;
        Поле.ТипЗначения = Колонка.ТипЗначения;
    КонецЦикла;
    
    URLСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
    
    КомпоновщикБуфер = Новый КомпоновщикНастроекКомпоновкиДанных;
    КомпоновщикБуфер.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
    КомпоновщикБуфер.ЗагрузитьНастройки(Компоновщик.ПолучитьНастройки());
    
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
    МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(
        СКД, 
        КомпоновщикБуфер.Настройки,,,
        Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
    );
    
    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных();
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, Новый Структура("НаборДанных1", ТаблицаЗначенийИсточник));
    
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
    ПроцессорВывода.УстановитьОбъект(ТаблицаЗначенийБуфер);
    
    ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
    ТаблицаЗначенийПолучатель.Загрузить(ТаблицаЗначенийИсточник);
    
КонецПроцедуры

// Функция - Получить таблицу значений
//
// Параметры:
//  Компоновщик  - КомпоновщикНастроекКомпоновкиДанных - Инициализированный компоновщик настроек компоновки данных, см. описание "ФункцииСКД.ИнициализироватьКомпоновщик".
//  ТекстЗапроса - Строка - Текст запроса получения данных. 
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица значений с полученными данными.
//
Функция ПолучитьТаблицуЗначений(Компоновщик, ТекстЗапроса) Экспорт
    
    КомпоновщикЗапрос = Новый КомпоновщикНастроекКомпоновкиДанных();
    СКД = Новый СхемаКомпоновкиДанных();
    
    ИсточникСКД = СКД.ИсточникиДанных.Добавить();
    ИсточникСКД.Имя = "ИсточникДанных1";
    ИсточникСКД.ТипИсточникаДанных = "local";
    НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
    НаборДанных.Запрос = ТекстЗапроса; 
    НаборДанных.ИсточникДанных = ИсточникСКД.Имя;
    НаборДанных.Имя = "НаборДанных1";
    URLСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
    КомпоновщикЗапрос.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
    КомпоновщикЗапрос.ЗагрузитьНастройки(Компоновщик.ПолучитьНастройки());
    УдалитьИзВременногоХранилища(URLСхемы);
    
    ТЗнБуфер = Новый ТаблицаЗначений;
   
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
    МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(
        СКД, 
        КомпоновщикЗапрос.Настройки,,,
        Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
    );
    
    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных();
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
    
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
    ПроцессорВывода.УстановитьОбъект(ТЗнБуфер);
        
    ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
    
    Возврат ТЗнБуфер;
    
КонецФункции

Функция КомпоновщикНастроекЕстьОтбор(КомпоновщикНастроек) Экспорт
    
    Настройки = КомпоновщикНастроек.ПолучитьНастройки();
    
    Возврат ЕстьОтбор(Настройки.Отбор);
    
КонецФункции

Функция ЕстьОтбор(Отбор)
    
    ЕстьОтбор = Ложь;
    
    Для Каждого ТекЭлемент Из Отбор.Элементы Цикл
        
        Если ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") И ТекЭлемент.Использование Тогда
            ЕстьОтбор = ЕстьОтбор(ТекЭлемент);
        Иначе
            ЕстьОтбор = ТекЭлемент.Использование;
        КонецЕсли;
                    
        Если ЕстьОтбор Тогда
            Прервать;
        КонецЕсли;
                
    КонецЦикла;
    
    Возврат ЕстьОтбор;
    
КонецФункции



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПолеВНаборДанных(Компоновщик, НаборДанных, ПолеНабораДанных)
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = ПолеНабораДанных.Поле;
    Поле.ПутьКДанным = ПолеНабораДанных.Поле;
    Поле.Заголовок = ПолеНабораДанных.Заголовок;
    Поле.ТипЗначения = ПолеНабораДанных.ОписаниеТипов;
    
    Если ПолеНабораДанных.Свойство("ОграничениеИспользованияРеквизитовУсловие") Тогда
        Поле.ОграничениеИспользованияРеквизитов.Условие = ПолеНабораДанных.ОграничениеИспользованияРеквизитовУсловие;
    КонецЕсли;
    
    Если ПолеНабораДанных.Свойство("ТипУпорядочивания") Тогда
        ЭлементПорядка = Компоновщик.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
        ЭлементПорядка.Поле = Новый ПолеКомпоновкиДанных(ПолеНабораДанных.Поле);
        ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных[ПолеНабораДанных.ТипУпорядочивания];
    КонецЕсли;
        
КонецПроцедуры

Процедура ДобавитьПолеВГруппировкуДанных(ГруппировкаКомпоновкиДанных, Компоновщик, ПолеНабораДанных)
    
    Поле = ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле.Использование = Истина;
    ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(ПолеНабораДанных.Поле);
    
КонецПроцедуры


#КонецОбласти

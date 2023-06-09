#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПрограммныйИнтерфейс
Функция ПолучитьДанные(
	Знач ОпорнаяДата,
	Знач НачальноеСмещение,
	Знач ЧислоТочек,
	Знач Шаг, 
	Статистика = Неопределено, 
	ВычислитьАгрегатныеЗначения = Истина, 
	ВычислитьГоризонтАктуальности = Ложь,
	РежимСдвига = Ложь
) Экспорт
	
	ЭтотОбъектКластер = ЭтотОбъект.Кластер;
	
	// Фильтр по кластерам 1с и базам
	ПараметрыУсловийНаКластер = Новый Массив;
	ПараметрыУсловийНаКластер.Добавить(Новый Структура("ЗаменяемаяСтрока, Префикс, Постфикс", "%УсловиеНаКластер", " И ", " "));
	
	Запрос = Новый Запрос;
	
	ЗапросТекст = "ВЫБРАТЬ
	|	ОбъединенныйЗапрос.Время КАК Время,
	|	ОбъединенныйЗапрос.ТекущееЗначение КАК ТекущееЗначение,
	|	ОбъединенныйЗапрос.ИнформационнаяБаза КАК ОбъектКонтроля,
	|	ОбъединенныйЗапрос.НомерИнтервала КАК НомерИнтервала
	|	
	|ПОМЕСТИТЬ ВТ_ВыборкаЗамеров
	|ИЗ
	|(ВЫБРАТЬ
	|	ОсновнаяТаблицаЗамеров.Период КАК Время,
	|	СУММА(ОсновнаяТаблицаЗамеров.Количество) КАК ТекущееЗначение,
	|	ОсновнаяТаблицаЗамеров.ИнформационнаяБаза КАК ИнформационнаяБаза,
	|	%ИндексацияИнтервалов
	|
	|ИЗ
	|	РегистрСведений.ЧислоВызововСервера КАК ОсновнаяТаблицаЗамеров
	|ГДЕ
	|	%УсловиеНаИнтервалДат
	|	%УсловиеНаБазу
	|	
	|СГРУППИРОВАТЬ ПО
	|	Период, ИнформационнаяБаза
	|
	|%ЗапросНаНачальноеЗначение
	|) КАК ОбъединенныйЗапрос";
	
	ШаблонЗапросаНачальногоЗначения = " 
	|ВЫБРАТЬ
	|	ВложенныйЗапрос%НомерЗапроса.Время КАК Время,
	|	ВложенныйЗапрос%НомерЗапроса.ТекущееЗначение КАК ТекущееЗначение,
	|	ВложенныйЗапрос%НомерЗапроса.ИнформационнаяБаза КАК ИнформационнаяБаза,
	|	-1 КАК НомерИнтервала
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 1
	|		ОсновнаяТаблицаЗамеров.Период КАК Время,
	|		СУММА(ОсновнаяТаблицаЗамеров.Количество) КАК ТекущееЗначение,
	|		ОсновнаяТаблицаЗамеров.ИнформационнаяБаза КАК ИнформационнаяБаза
	|		ИЗ
	|			РегистрСведений.ЧислоВызововСервера КАК ОсновнаяТаблицаЗамеров
	|		ГДЕ
	|			ОсновнаяТаблицаЗамеров.ИнформационнаяБаза = &ИнформационнаяБаза%НомерЗапроса
	|			И ОсновнаяТаблицаЗамеров.Период < &ВремяЗамеровНачало
	|	СГРУППИРОВАТЬ ПО
	|		Период, ИнформационнаяБаза
	|	УПОРЯДОЧИТЬ ПО
	|		Период УБЫВ
	|	) КАК ВложенныйЗапрос%НомерЗапроса " ;
	
	ЗапросНачальныхЗначений = "";
	НомерБазы = 1;
	Для Каждого БазаСтрока Из ЭтотОбъект.ИнформационныеБазы Цикл
		БазаСсылка = БазаСтрока.ИнформационнаяБазаСсылка;
		НомерБазыСтрокой = ОбщийКлиентСервер.ЧислоВСтроку(НомерБазы);
		ТекстПодзапроса = СтрЗаменить(ШаблонЗапросаНачальногоЗначения, "%НомерЗапроса", НомерБазыСтрокой);
		Запрос.УстановитьПараметр("ИнформационнаяБаза" + НомерБазы, БазаСсылка);
		
		ЗапросНачальныхЗначений = ЗапросНачальныхЗначений + " ОБЪЕДИНИТЬ ВСЕ" + ТекстПодзапроса;
		
		НомерБазы = НомерБазы + 1;
	КонецЦикла;
	
	ЗапросТекст = СтрЗаменить(ЗапросТекст, "%ЗапросНаНачальноеЗначение", ЗапросНачальныхЗначений);
	
	// Фильтр по кластерам 1с и базам
	ПараметрыУсловийНаБазу = Новый Массив;
	ПараметрыУсловийНаБазу.Добавить(Новый Структура("ЗаменяемаяСтрока, Префикс, Постфикс", "%УсловиеНаБазу", " И ", " "));
	
	УстановитьФильтрПоОбъектамКонтроля(Запрос, ЗапросТекст, 
		ПараметрыУсловийНаБазу
	);
	
	ТребуемаяДатаНачала = ОпорнаяДата + НачальноеСмещение;
	Запрос.УстановитьПараметр("ВремяЗамеровНачало", ТребуемаяДатаНачала);
	Замеры = МониторингСервер.ВыбратьДанныеПоРешеткеДат(
		ЭтотОбъект.Ссылка,
		ОпорнаяДата,
		НачальноеСмещение,
		ЧислоТочек,
		Шаг,
		Запрос,
		ЗапросТекст,
		"Период",
		Шаг
	);
	
	Если Статистика <> Неопределено Тогда
		Если ВычислитьАгрегатныеЗначения Тогда
			ДатаНачала = ОпорнаяДата + НачальноеСмещение * Шаг;
			ДатаОкончания = ОпорнаяДата + (НачальноеСмещение + ЧислоТочек - 1) * Шаг;
			ОбновитьСтатистику(ДатаНачала, ДатаОкончания, Статистика);
			
			// вычислим параметр "Текущее" 
			Попытка
				Если Статистика.Кол > 0 Тогда
					ТекущееЗначение = Замеры[Замеры.Количество() - 1].Среднее;
				Иначе 
					ТекущееЗначение = 0;
				КонецЕсли;
			Исключение
				Инфо = ИнформацияОбОшибке();
				Комментарий =
					"Описание = '" +Инфо.Описание + "', " +
					"ИмяМодуля = '" + Инфо.ИмяМодуля + "', " +
					"НомерСтроки = '" + Инфо.НомерСтроки + "', " +
					"ИсходнаяСтрока = '" + Инфо.ИсходнаяСтрока + "'.";
			
				ЗаписьЖурналаРегистрации(
					"Функция ПолучитьДанные(...)",
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники.ТекущееЧислоВызововСервера.МодульОбъекта,
					,
					Комментарий);
					
				ТекущееЗначение = 0;
			КонецПопытки;
			Статистика.Вставить("Текущее", ТекущееЗначение);

		КонецЕсли;
		
		Если ВычислитьГоризонтАктуальности Тогда
			
			Статистика.Вставить("Горизонт", ТекущаяДата());
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Замеры;
	
КонецФункции

Функция ПолучитьДанныеОбнаруженияИнцидентов(ОпорнаяДата, Смещение, АгрегирующаяФункция, ФорматнаяСтрокаЗначения) Экспорт
    
    Данные = Неопределено;
	
	Запрос = Новый Запрос;
    
    Запрос.Текст = "
    |ВЫБРАТЬ
    |   {АгрегирующаяФункция}(Количество) КАК Значение
    |ИЗ
    |   Справочник.ТекущееЧислоВызововСервера.ИнформационныеБазы КАК ИнформационныеБазы
    |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
    |   РегистрСведений.ПараметрыИнформационныхБаз КАК ПараметрыИБ
    |ПО
    |   ПараметрыИБ.ОбъектКонтроля = ИнформационныеБазы.ИнформационнаяБазаСсылка
    |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
    |   РегистрСведений.ЧислоВызововСервера КАК Данные
    |ПО
    |   Данные.ИнформационнаяБаза = ИнформационныеБазы.ИнформационнаяБазаСсылка
    |   И Данные.Кластер = ПараметрыИБ.Кластер
    |   И Данные.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
    |ГДЕ
    |   ИнформационныеБазы.Ссылка = &Ссылка
    |";
    
    Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	Запрос.УстановитьПараметр("ДатаНачала", ОпорнаяДата - Смещение);
	Запрос.УстановитьПараметр("ДатаОкончания", ОпорнаяДата);
    
    Если АгрегирующаяФункция = Перечисления.ФункцииОповещений.Минимум Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{АгрегирующаяФункция}", "МИНИМУМ");
	ИначеЕсли АгрегирующаяФункция = Перечисления.ФункцииОповещений.Среднее Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{АгрегирующаяФункция}", "СРЕДНЕЕ");
	ИначеЕсли АгрегирующаяФункция = Перечисления.ФункцииОповещений.Максимум Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{АгрегирующаяФункция}", "МАКСИМУМ");
	ИначеЕсли АгрегирующаяФункция = Перечисления.ФункцииОповещений.Сумма Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{АгрегирующаяФункция}", "СУММА");
	КонецЕсли;
    
    Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если Выборка.Значение <> Null Тогда
		Данные = Новый Массив;
		Данные.Добавить(Выборка.Значение);
		Если ЗначениеЗаполнено(ФорматнаяСтрокаЗначения) Тогда
			ИндексНачала = СтрНайти(ФорматнаяСтрокаЗначения, "[");
			ИндексОкончания = СтрНайти(ФорматнаяСтрокаЗначения, "]");
	        Если ИндексНачала > 0 И ИндексОкончания > 0 Тогда
				ФорматнаяСтрокаЗначенияБуфер = Сред(ФорматнаяСтрокаЗначения, ИндексНачала + 1, ИндексОкончания - ИндексНачала - 1);
			Иначе
				ФорматнаяСтрокаЗначенияБуфер = ФорматнаяСтрокаЗначения;
			КонецЕсли;
			
			ЗначениеСообщить = СтрЗаменить(ФорматнаяСтрокаЗначения, "[" + ФорматнаяСтрокаЗначенияБуфер + "]", Формат(Выборка.Значение, ФорматнаяСтрокаЗначенияБуфер));
		Иначе
			ЗначениеСообщить = Выборка.Значение;
		КонецЕсли;
		Сообщить(ЭтотОбъект.Ссылка.Описание + " = " + ЗначениеСообщить + " [" + АгрегирующаяФункция + "]");
	Иначе
		Сообщить(ЭтотОбъект.Ссылка.Описание + " - нет данных в регистре сведений 'ЧислоВызововСервера'!");
	КонецЕсли;
		
	Возврат Данные;
        
КонецФункции

#КонецОбласти


Функция УстановитьФильтрПоОбъектамКонтроля(
	Запрос, 
	ЗапросТекст,
	ПараметрыУсловийНаБазу
)
	
	СписокБаз = СписокБаз();
	Если СписокБаз.Количество() = 1 Тогда
		УсловиеНаБазу = " ОсновнаяТаблицаЗамеров.ИнформационнаяБаза = &СписокБазПерваяБаза ";
		Запрос.УстановитьПараметр("СписокБазПерваяБаза", СписокБаз[0]);
	Иначе
		УсловиеНаБазу = " ОсновнаяТаблицаЗамеров.ИнформационнаяБаза В (&СписокБаз) ";
		Запрос.УстановитьПараметр("СписокБаз", СписокБаз());
	КонецЕсли;
	
	Для Каждого ПараметрУсловий Из ПараметрыУсловийНаБазу Цикл
		ТекущееУсловиеНаБазу = УсловиеНаБазу;
		Префикс = ПараметрУсловий.Префикс;
		Постфикс = ПараметрУсловий.Постфикс;
		Если НЕ ПустаяСтрока(ТекущееУсловиеНаБазу) Тогда
			ТекущееУсловиеНаБазу = Префикс + ТекущееУсловиеНаБазу + Постфикс;
		КонецЕсли;
		ЗапросТекст = СтрЗаменить(ЗапросТекст, ПараметрУсловий.ЗаменяемаяСтрока, ТекущееУсловиеНаБазу);
	КонецЦикла;
	
КонецФункции

Функция СписокБаз()
	СписокБаз = Новый Массив;
	Для Каждого БазаСтрока Из ЭтотОбъект.ИнформационныеБазы Цикл
		СписокБаз.Добавить(БазаСтрока.ИнформационнаяБазаСсылка);
	КонецЦикла;
	Возврат СписокБаз;
КонецФункции

Функция ОбновитьСтатистику(Знач ДатаНачала, Знач ДатаОкончания, Статистика) Экспорт
	
	Запрос = Новый Запрос;
	
	ЗапросТекст = "
	|ВЫБРАТЬ
	|	0 КАК РежимЗапроса,
	|	ВложенныйЗапрос.ИнформационнаяБаза КАК ОбъектКонтроля,
	|	0 КАК Всего,
	|	СРЕДНЕЕ(ВложенныйЗапрос.ТекущееЗначение) КАК Сред,
	|	МАКСИМУМ(ВложенныйЗапрос.ТекущееЗначение) КАК Макс,
	|	МИНИМУМ(ВложенныйЗапрос.ТекущееЗначение) КАК Мин,
	|	КОЛИЧЕСТВО(ВложенныйЗапрос.ТекущееЗначение) КАК Кол
	|
	|ИЗ
	|(ВЫБРАТЬ
	|	СУММА(ОсновнаяТаблицаЗамеров.Количество) КАК ТекущееЗначение,
	|	ОсновнаяТаблицаЗамеров.ИнформационнаяБаза КАК ИнформационнаяБаза
	|ИЗ
	|	РегистрСведений.ЧислоВызововСервера КАК ОсновнаяТаблицаЗамеров
	|ГДЕ
	|	%УсловиеНаБазу 
	|	ОсновнаяТаблицаЗамеров.Период >= &ДатаНачала
	|	И ОсновнаяТаблицаЗамеров.Период <= &ДатаОкончания
	|	
	|СГРУППИРОВАТЬ ПО
	|	Период, ИнформационнаяБаза
	|) КАК ВложенныйЗапрос
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ИнформационнаяБаза ";
	
	// Фильтр по кластерам 1с и базам
	ПараметрыУсловийНаКластер = Новый Массив;
	
	ПараметрыУсловийНаБазу = Новый Массив;
	ПараметрыУсловийНаБазу.Добавить(Новый Структура("ЗаменяемаяСтрока, Префикс, Постфикс", "%УсловиеНаБазу", " ", " И "));
	ПараметрыУсловийНаБазу.Добавить(Новый Структура("ЗаменяемаяСтрока, Префикс, Постфикс", "%ВсегоУсловиеНаБазу", " ", " И "));
	
	УстановитьФильтрПоОбъектамКонтроля(Запрос, ЗапросТекст,	ПараметрыУсловийНаБазу);
	
	МониторингСервер.УстановитьПараметрыДатыВЗапросе(Запрос, ДатаНачала, ДатаОкончания);
	
	Запрос.Текст = ЗапросТекст;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Сред = 0;
	Макс = 0;
	Мин = 0;
	Всего = 0;
	ОбщееКоличество = 0;
	ПоследнееСреднее = Неопределено;
	Пока Выборка.Следующий() Цикл
		Если Выборка.РежимЗапроса = 0 Тогда
			Кол = Выборка.Кол;
			Если Кол > 0 Тогда
				Сред = Сред + Выборка.Сред;
				Макс = Макс + Выборка.Макс;
				Мин = Мин + Выборка.Мин;
				ПоследнееСреднее = Выборка.Сред;
			КонецЕсли;
			ОбщееКоличество = ОбщееКоличество + Кол;
		КонецЕсли;
	КонецЦикла;
	
	Если ОбщееКоличество = 0 Тогда
		Сред = "";
		Макс = "";
		Мин = "";
	КонецЕсли;
	Статистика.Вставить("Сред", Сред);
	Статистика.Вставить("Макс", Макс);
	Статистика.Вставить("Мин", Мин);
	Статистика.Вставить("Всего", Всего);
	Статистика.Вставить("Кол", ОбщееКоличество);
	
	// вычислим параметр "Текущее" 
	Попытка
		Если Статистика.Кол > 0 Тогда
			ТекущееЗначение = ПоследнееСреднее;
		Иначе 
			ТекущееЗначение = 0;
		КонецЕсли;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Комментарий =
			"Описание = '" +Инфо.Описание + "', " +
			"ИмяМодуля = '" + Инфо.ИмяМодуля + "', " +
			"НомерСтроки = '" + Инфо.НомерСтроки + "', " +
			"ИсходнаяСтрока = '" + Инфо.ИсходнаяСтрока + "'.";
			
		ЗаписьЖурналаРегистрации(
			"Функция ОбновитьСтатистику(Знач ДатаНачала, Знач ДатаОкончания, Статистика) Экспорт",
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Справочники.ТекущееЧислоВызововСервера.МодульОбъекта,
			,
			Комментарий);
		
		ТекущееЗначение = 0;
	КонецПопытки;
	Статистика.Вставить("Текущее", ТекущееЗначение);
	
КонецФункции

Функция ИдентификаторВариантаПоказателя() Экспорт
	
	ФильтрПоОбъектамКонтроля = Новый Массив;
	ФильтрПоОбъектамКонтроля.Добавить(Новый Структура(
		"НазваниеРеквизитаВсеОбъектыКонтроля, НазваниеРеквизитаОбъектКонтроля",
		"ВсеКластеры",
		"Кластер"
	));
	ИД = МониторингСервер.ОбщаяЧастьИдентификатораВариантаПоказателя(
		ЭтотОбъект,
		ФильтрПоОбъектамКонтроля
	);
	РазделительПолей = "__";
	ИД = ИД + РазделительПолей;
	Для Каждого СтрокаБазы Из ЭтотОбъект.ИнформационныеБазы Цикл
		ИД = ИД + "_" + Строка(СтрокаБазы.ИнформационнаяБазаСсылка.УникальныйИдентификатор());
	КонецЦикла;

	Возврат ИД;
КонецФункции

// Возвращает текстовую строку, описывающую тип показателя
//
// Возвращаемое значение:
//  Строка
//
Функция ИдентификаторТипаПоказателя() Экспорт
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Метаданные().РасширенноеПредставлениеОбъекта) Тогда
		Возврат ЭтотОбъект.Метаданные().РасширенноеПредставлениеОбъекта;
	ИначеЕсли ЗначениеЗаполнено(ЭтотОбъект.Метаданные().ПредставлениеОбъекта) Тогда
		Возврат ЭтотОбъект.Метаданные().ПредставлениеОбъекта;
	Иначе
		Возврат ЭтотОбъект.Метаданные().Синоним;
	КонецЕсли;
	
КонецФункции

// Заполняет параметры по умолчанию отображения показателя на графике
// 
// Параметры:
//  ПараметрОповещения - Структура - см.МониторингСервер.ПараметрОповещенияПоказательЗаписан()
//
Процедура ЗаполнитьПараметрыОтображенияПоУмолчанию(Знач ПараметрОповещения) Экспорт
	ГСЧ = Новый ГенераторСлучайныхЧисел();
	
	ПараметрОповещения.Цвет = Новый Цвет(ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255), ГСЧ.СлучайноеЧисло(0,255));
	ПараметрОповещения.АвтоМасштаб = Истина;
	ПараметрОповещения.Масштаб = 1;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Описание) Тогда
		Описание = Описание();
	КонецЕсли;	
КонецПроцедуры

Функция Описание()
	
	НаименованиеВСтроку = ИдентификаторТипаПоказателя();
	
	НастройкиВСтроку = "";
	НастройкиВСтроку = НастройкиВСтроку + ?(ПустаяСтрока(НастройкиВСтроку), "", ", ") + "информационные базы = [" + 
		МониторингСервер.ИнформационныеБазыВСтроку(ИнформационныеБазы.ВыгрузитьКолонку("ИнформационнаяБазаСсылка")) + "]";
	
	Если НЕ ПустаяСтрока(НастройкиВСтроку) Тогда
		НаименованиеВСтроку = НаименованиеВСтроку + " (" + НастройкиВСтроку + ")";
	КонецЕсли;
	
	Возврат НаименованиеВСтроку;
	
КонецФункции

// Расчитывает данные показателя по периодам
//
//	Параметры:
// 		МенеджерВременныхТаблиц	- МенеджерВременныхТаблиц. Временные таблицы с периодами и показателями.
// 		Детализация				- ТипДополненияПериодаКомпоновкиДанных. Период детализации.
//
//	Возвращаемое значение:
//		ТаблицаДанных. ТаблицаЗначений. Данные показателя.
//
Функция РасчитатьПоказатель(МенеджерВременныхТаблиц, Детализация = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ПоказательМониторинга", ЭтотОбъект.Владелец);
	Запрос.УстановитьПараметр("Показатель", ЭтотОбъект.Ссылка);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаПодготовительная.ДатаТочки КАК ДатаТочки,
	|	ТаблицаПодготовительная.ДатаТочкиСледующая КАК ДатаТочкиСледующая,
	|	ТаблицаПодготовительная.ДатаТочкиДанные КАК ДатаТочкиДанные,
	|	ТаблицаПодготовительная.ДатаТочкиДанныеСледующая КАК ДатаТочкиДанныеСледующая
	|ИЗ
	|	ТаблицаПодготовительная КАК ТаблицаПодготовительная
	|ГДЕ
	|	ТаблицаПодготовительная.ПоказательМониторинга = &ПоказательМониторинга
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаТочки
	|";
	
	ВыборкаТочки = Запрос.Выполнить().Выбрать();
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаПодготовительная.ДатаТочки КАК ДатаТочки,
	|	МАКСИМУМ(ВложенныйЗапрос.Максимальное) КАК Максимальное,
	|	МИНИМУМ(ВложенныйЗапрос.Минимальное) КАК Минимальное,
	|	СРЕДНЕЕ(ВложенныйЗапрос.Значение) КАК Значение
	|
	|ИЗ
	|	ТаблицаПодготовительная КАК ТаблицаПодготовительная
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|
	|	(
	|	ВЫБРАТЬ
	|		ДАТАВРЕМЯ(1,1,1,0,0,0) КАК ДатаТочки,
	|		0 КАК Максимальное,
	|		0 КАК Минимальное,
	|		0 КАК Значение
	|	ГДЕ
	|		Ложь
	|";
	
	СчТочек = 1;
	
	Пока ВыборкаТочки.Следующий() Цикл
		
		ИмяПараметра				= "Точка" + Формат(ВыборкаТочки.ДатаТочкиДанные, "ДФ=yyyyMMddHHmmss");
		ИмяПараметраСледующая		= "ТочкаСледующая" + Формат(ВыборкаТочки.ДатаТочкиДанныеСледующая, "ДФ=yyyyMMddHHmmss");
		ИмяПараметраДанные			= "ТочкаДанные" + Формат(ВыборкаТочки.ДатаТочкиДанные, "ДФ=yyyyMMddHHmmss");
		ИмяПараметраДанныеСледующая	= "ТочкаДанныеСледующая" + Формат(ВыборкаТочки.ДатаТочкиДанныеСледующая, "ДФ=yyyyMMddHHmmss");
		
		Запрос.УстановитьПараметр(ИмяПараметра, ВыборкаТочки.ДатаТочки);
		Запрос.УстановитьПараметр(ИмяПараметраСледующая, ВыборкаТочки.ДатаТочкиСледующая);
		Запрос.УстановитьПараметр(ИмяПараметраДанные, ВыборкаТочки.ДатаТочкиДанные);
		Запрос.УстановитьПараметр(ИмяПараметраДанныеСледующая, ВыборкаТочки.ДатаТочкиДанныеСледующая);
		
		Если Детализация = ТипДополненияПериодаКомпоновкиДанных.Минута
			ИЛИ Детализация = ТипДополненияПериодаКомпоновкиДанных.Секунда 
			ИЛИ СчТочек = 1 ИЛИ СчТочек = ВыборкаТочки.Количество()  Тогда
				
			ТекстЗапросаШаблон = "
			|
			|	ОБЪЕДИНИТЬ ВСЕ
			|
			|	ВЫБРАТЬ
			|		&ДатаТочкиТекущая КАК ДатаТочки,
			|		МАКСИМУМ(ОсновнаяТаблицаЗамеров.Количество) КАК Максимальное,
			|		МИНИМУМ(ОсновнаяТаблицаЗамеров.Количество) КАК Минимальное,
			|		СРЕДНЕЕ(ОсновнаяТаблицаЗамеров.Количество) КАК Значение
			|
			|	ИЗ
			|		РегистрСведений.ЧислоВызововСервера КАК ОсновнаяТаблицаЗамеров
			|
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ТекущееЧислоВызововСервера.ИнформационныеБазы КАК ТекущееЧислоВызововСервераИнформационныеБазы
			|		ПО ОсновнаяТаблицаЗамеров.ИнформационнаяБаза = ТекущееЧислоВызововСервераИнформационныеБазы.ИнформационнаяБазаСсылка
			|		И ТекущееЧислоВызововСервераИнформационныеБазы.Ссылка = &Показатель
			|
			|	ГДЕ
			|		ОсновнаяТаблицаЗамеров.Период > &ДатаТочкиДанныеТекущая
			|		И ОсновнаяТаблицаЗамеров.Период <= &ДатаТочкиДанныеСледующая
			|";
			
		Иначе
			
			ТекстЗапросаШаблон = "
			|
			|	ОБЪЕДИНИТЬ ВСЕ
			|
			|	ВЫБРАТЬ
			|		&ДатаТочкиТекущая КАК ДатаТочки,
			|		МАКСИМУМ(ОсновнаяТаблицаЗамеров.ЧислоВызововСервераМаксимум) КАК Максимальное,
			|		МИНИМУМ(ОсновнаяТаблицаЗамеров.ЧислоВызововСервераМинимум) КАК Минимальное,
			|		СРЕДНЕЕ(ВЫБОР КОГДА ОсновнаяТаблицаЗамеров.ЧислоВызововСервераКоличество = 0 ТОГДА 0 ИНАЧЕ ОсновнаяТаблицаЗамеров.ЧислоВызововСервераСумма / ОсновнаяТаблицаЗамеров.ЧислоВызововСервераКоличество КОНЕЦ) КАК Значение
			|	ИЗ
			|		РегистрСведений.СтатистикаПоИнформационнымБазамИтоги КАК ОсновнаяТаблицаЗамеров
			|
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ТекущееЧислоВызововСервера.ИнформационныеБазы КАК ТекущееЧислоВызововСервераИнформационныеБазы
			|		ПО ОсновнаяТаблицаЗамеров.ИнформационнаяБаза = ТекущееЧислоВызововСервераИнформационныеБазы.ИнформационнаяБазаСсылка
			|		И ТекущееЧислоВызововСервераИнформационныеБазы.Ссылка = &Показатель
			|
			|	ГДЕ
			|		ОсновнаяТаблицаЗамеров.ПериодЧас > &ДатаТочкиДанныеТекущая
			|		И ОсновнаяТаблицаЗамеров.ПериодЧас <= &ДатаТочкиДанныеСледующая
			|";
			
			Если Детализация <> ТипДополненияПериодаКомпоновкиДанных.Час Тогда
				ТекстЗапросаШаблон = СтрЗаменить(ТекстЗапросаШаблон, "ПериодЧас", "Период");
			КонецЕсли;
			
		КонецЕсли;
		
		ТекстЗапросаШаблон = СтрЗаменить(ТекстЗапросаШаблон, "&ДатаТочкиТекущая", "&" + ИмяПараметра);
		ТекстЗапросаШаблон = СтрЗаменить(ТекстЗапросаШаблон, "&ДатаТочкиСледующая", "&" + ИмяПараметраСледующая);
		ТекстЗапросаШаблон = СтрЗаменить(ТекстЗапросаШаблон, "&ДатаТочкиДанныеТекущая", "&" + ИмяПараметраДанные);
		ТекстЗапросаШаблон = СтрЗаменить(ТекстЗапросаШаблон, "&ДатаТочкиДанныеСледующая", "&" + ИмяПараметраДанныеСледующая);
		
		Запрос.Текст = Запрос.Текст + "
		|" + ТекстЗапросаШаблон;
		
		СчТочек = СчТочек + 1;
		
	КонецЦикла;
	
	Запрос.Текст = Запрос.Текст + "
	|
	|	) КАК ВложенныйЗапрос
	|	ПО ТаблицаПодготовительная.ПоказательМониторинга = &ПоказательМониторинга
	|	И ВложенныйЗапрос.ДатаТочки = ТаблицаПодготовительная.ДатаТочки
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПодготовительная.ДатаТочки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаТочки
	|";

	ТаблицаДетальныхДанных = Запрос.Выполнить().Выгрузить();
	
	МассивПолей = Новый Массив();
	МассивПолей.Добавить("Значение");
	
	РасчетИтоговПоказателей.ЗаполнитьПустыеДанныеПредыдущимиЗначениями(ТаблицаДетальныхДанных, МассивПолей, Null);
	
	Если ЭтотОбъект.Владелец.ПоказыватьТренд Тогда
		РасчетИтоговПоказателей.СгладитьДанные(ТаблицаДетальныхДанных, ЭтотОбъект.Владелец.ТипСглаживания, ЭтотОбъект.Владелец.КоличествоУсредняемыхЗначений);
	КонецЕсли;
	
	Возврат ТаблицаДетальныхДанных;
	
КонецФункции

#КонецЕсли

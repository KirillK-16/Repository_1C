#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	// Отключаем стандартный вывод отчета - будем выводить программно 
	СтандартнаяОбработка = Ложь;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();						// Получаем настройки отчета
	ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;  // Получаем пользовательские настройки
	
	ПараметрВыводитьДиаграмму = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьДиаграмму"));
	ЭлементВыводитьДиаграмму = ПользовательскиеНастройки.Элементы.Найти(ПараметрВыводитьДиаграмму.ИдентификаторПользовательскойНастройки);
		
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;				// Создаем данные расшифровки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;				// Создаем компоновщик макета 
	
	Результат = ПолучитьДанныеДляВывода(Настройки, ПользовательскиеНастройки);
	ТЗнДанные = Результат.ТЗнДанные;
	ТЗнКонфигурации = Результат.ТЗнКонфигурации;
	
	НастройкиКоличествоКонфигураций = 0;
	НастройкиКоличествоВерсий = 0;
	Если ТЗнКонфигурации.Количество() > 0 Тогда
		НастройкиКоличествоКонфигураций = ТЗнКонфигурации[0].КоличествоКонфигураций;	
		НастройкиКоличествоВерсий = ТЗнКонфигурации[0].КоличествоВерсий;
	КонецЕсли;
	
	Если ЭлементВыводитьДиаграмму.Значение Тогда
		Если НастройкиКоличествоКонфигураций < 2 ИЛИ НастройкиКоличествоВерсий < 2 Тогда
			ГистограммаИспользование = Ложь;
			ГрафикИспользование = Истина;
		Иначе
			ГистограммаИспользование = Истина;
			ГрафикИспользование = Ложь;
		КонецЕсли;
	Иначе
		ГистограммаИспользование = Ложь;
		ГрафикИспользование = Ложь;
	КонецЕсли;
	
	Для Каждого ТекНастройка Из Настройки.Структура Цикл
		Если ТекНастройка.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипДиаграммы")).Значение = ТипДиаграммы.Гистограмма Тогда
			ТекНастройка.Использование = ГистограммаИспользование;	
		ИначеЕсли ТекНастройка.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТипДиаграммы")).Значение = ТипДиаграммы.График Тогда
			ТекНастройка.Использование = ГрафикИспользование;
		КонецЕсли;
	КонецЦикла;
	
	// Инициализируем макет компоновки используя схему компоновки данных 
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	// Скомпонуем результат
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПараметрыПроцессораКомпоновки = Новый Структура("НаборДанныхОценкаПроизводительности", ТЗнДанные);
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ПараметрыПроцессораКомпоновки, ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если ДокументРезультат.Рисунки.Количество() > 0 Тогда
		ДокументРезультат.Рисунки[0].Ширина = 310;
		
		Диаграмма = ДокументРезультат.Рисунки[0].Объект;
		Диаграмма.Анимация = АнимацияДиаграммы.НеИспользовать;
		
		Диаграмма.ОбластьПостроения.Верх = 0;
		Диаграмма.ОбластьПостроения.Низ = 1;
		Диаграмма.ОбластьПостроения.Лево = 0;
		Диаграмма.ОбластьПостроения.Право = 1;
		Диаграмма.ОтображатьЛегенду = Ложь;
		Диаграмма.ПоложениеПодписей = ПоложениеПодписейКДиаграмме.Центр;
		Диаграмма.ОбластьПостроения.ОриентацияМеток = ОриентацияМетокДиаграммы.Вертикально;
		
		Для Каждого ТекТочка Из Диаграмма.Точки Цикл
			ТекТочка.ПриоритетЦвета = Истина;
		КонецЦикла;
		
		Если ГистограммаИспользование Тогда
			ВсегоТочек = Диаграмма.Точки.Количество();
			Для ТекИндекс = ВсегоТочек По 15 Цикл
				Диаграмма.Точки.Добавить("");
			КонецЦикла;
		КонецЕсли;
		
		Если ГрафикИспользование Тогда
			Для Каждого ТекСерия Из Диаграмма.Серии Цикл
				ТекСерия.Маркер = ТипМаркераДиаграммы.Нет;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
		
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(1);
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(0);
КонецПроцедуры

Функция ПолучитьДанныеДляВывода(Настройки, ПользовательскиеНастройки)
	ПараметрПериод = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	ПараметрКонфигурация = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Конфигурация"));
	ПараметрВерсияКонфигурации = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВерсияКонфигурации"));
	ПараметрКлючевыеОперации = Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КлючевыеОперации"));
		
	ЭлементПериод = ПользовательскиеНастройки.Элементы.Найти(ПараметрПериод.ИдентификаторПользовательскойНастройки);
	ЭлементКонфигурация = ПользовательскиеНастройки.Элементы.Найти(ПараметрКонфигурация.ИдентификаторПользовательскойНастройки);
	ЭлементВерсияКонфигурации = ПользовательскиеНастройки.Элементы.Найти(ПараметрВерсияКонфигурации.ИдентификаторПользовательскойНастройки);
	ЭлементКлючевыеОперации = ПользовательскиеНастройки.Элементы.Найти(ПараметрКлючевыеОперации.ИдентификаторПользовательскойНастройки);
	
	ДатаНачала = ЭлементПериод.Значение.ДатаНачала;
	ДатаОкончания = ЭлементПериод.Значение.ДатаОкончания;
	
	СписокКонфигураций = Неопределено;
	Если ЭлементКонфигурация.Использование Тогда
		СписокКонфигураций = ЭлементКонфигурация.Значение;
	КонецЕсли;
	
	СписокВерсийКонфигураций = Неопределено;
	Если ЭлементВерсияКонфигурации.Использование Тогда
		СписокВерсийКонфигураций = ЭлементВерсияКонфигурации.Значение;
	КонецЕсли;
	
	СписокКлючевыхОпераций = Неопределено;
	Если ЭлементКлючевыеОперации.Использование Тогда
		СписокКлючевыхОпераций = ЭлементКлючевыеОперации.Значение;
	КонецЕсли;
			
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	РегСвИнфИстория.Конфигурация КАК Конфигурация,
	|	РегСвИнфИстория.ИнформационнаяБаза КАК ИнформационнаяБаза,
	|	СпрВерсииКонфигурации.Ссылка КАК ВерсияКонфигурации,
	|	СпрВерсииКонфигурации.ВерсияЧисло КАК ВерсияЧисло,
	|	МИНИМУМ(РегСвИнфИстория.Период) КАК ДатаНачала
	|ИЗ
	|	РегистрСведений.ИнформацияСрезПоследних КАК РегСвИнфСрезПоследних
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ИнформацияИстория КАК РегСвИнфИстория
	|ПО
	|	РегСвИнфИстория.ИнформационнаяБаза = РегСвИнфСрезПоследних.ИнформационнаяБаза
	|	И РегСвИнфИстория.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И РегСвИнфИстория.Конфигурация = РегСвИнфСрезПоследних.Конфигурация
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Справочник.ВерсииКонфигурации КАК СпрВерсииКонфигурации
	|ПО
	|	СпрВерсииКонфигурации.Ссылка = РегСвИнфИстория.ВерсияКонфигурации
	|	{И СпрВерсииКонфигурации.Ссылка В (&СписокВерсийКонфигураций)}
	|{ГДЕ
	|	РегСвИнфСрезПоследних.Конфигурация В (&СписокКонфигураций)}
	|СГРУППИРОВАТЬ ПО
	|	РегСвИнфИстория.Конфигурация,
	|	РегСвИнфИстория.ИнформационнаяБаза,
	|	СпрВерсииКонфигурации.Ссылка,
	|	СпрВерсииКонфигурации.ВерсияЧисло
	|УПОРЯДОЧИТЬ ПО
	|	РегСвИнфИстория.Конфигурация,
	|	РегСвИнфИстория.ИнформационнаяБаза,
	|	СпрВерсииКонфигурации.ВерсияЧисло ВОЗР
	|";
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	Если ЗначениеЗаполнено(СписокКонфигураций) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{ГДЕ
			|	РегСвИнфСрезПоследних.Конфигурация В (&СписокКонфигураций)}" , "ГДЕ
			|	РегСвИнфСрезПоследних.Конфигурация В (&СписокКонфигураций)");
		Запрос.УстановитьПараметр("СписокКонфигураций", СписокКонфигураций);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СписокВерсийКонфигураций) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{И СпрВерсииКонфигурации.Ссылка В (&СписокВерсийКонфигураций)}", "И СпрВерсииКонфигурации.Ссылка В (&СписокВерсийКонфигураций)");
		Запрос.УстановитьПараметр("СписокВерсийКонфигураций", СписокВерсийКонфигураций);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{И СпрВерсииКонфигурации.Ссылка В (&СписокВерсийКонфигураций)}", "");
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	ТЗн = Результат.Выгрузить();
	ТЗн.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата"));
	
	МаксИндекс = ТЗн.Количество() - 2;
	Для ТекИндекс = 0 По МаксИндекс Цикл
		ТекСтрока = ТЗн[ТекИндекс];
		СледСтрока = ТЗн[ТекИндекс + 1];
		ТекСтрока.ДатаНачала = НачалоДня(ТекСтрока.ДатаНачала);
		Если ТекСтрока.ИнформационнаяБаза <> СледСтрока.ИнформационнаяБаза Тогда
			ТекСтрока.ДатаОкончания = НачалоДня(ДатаОкончания);
		Иначе
			ТекСтрока.ДатаОкончания = НачалоДня(СледСтрока.ДатаНачала);
		КонецЕсли;
	КонецЦикла;
	
	Если ТЗн.Количество() <> 0 Тогда 
		ТекСтрока = ТЗн[МаксИндекс + 1];
		ТекСтрока.ДатаОкончания = НачалоДня(ДатаОкончания);
	КонецЕсли;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Конфигурация,
	|	ИнформационнаяБаза,
	|	ВерсияКонфигурации,
	|	ВерсияЧисло,
	|	ДатаНачала,
	|	ДатаОкончания
	|ПОМЕСТИТЬ
	|	ИнформационныеБазы
	|ИЗ
	|	&ТаблицаИнформационныеБазы КАК ТаблицаИнформационныеБазы
	|ИНДЕКСИРОВАТЬ ПО
	|	ИнформационнаяБаза
	|;
	//Начало выборки операций Центра мониторинга
	|ВЫБРАТЬ
	|	Ссылка
	|ПОМЕСТИТЬ
	|	КлючевыеОперацииЦентраМониторинга
	|ИЗ
	|	Справочник.КлючевыеОперацииЦентрМониторинга
	|ГДЕ
	|	Наименование ПОДОБНО ""Центр мониторинга%""
	|;
	//Конец выборки операций Центра мониторинга
	//=============================================================================
	//Начало выборки количество различных ИБ по КлючеваяОперация_ВерсияКонфигурации
	|ВЫБРАТЬ
	|	ИнформационныеБазы.Конфигурация КАК Конфигурация,
	|	ИнформационныеБазы.ВерсияКонфигурации КАК ВерсияКонфигурации,
	|	РегСвОценкаПроизводительности.КлючеваяОперация КАК КлючеваяОперация,
	|	РегСвОценкаПроизводительности.ЦелевоеВремя КАК ЦелевоеВремя,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИнформационныеБазы.ИнформационнаяБаза) КАК КоличествоИБ
	|ПОМЕСТИТЬ
	|	КлючевыеОперацииВерсияИБКоличествоИБ
	|ИЗ
	|	ИнформационныеБазы КАК ИнформационныеБазы
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОценкаПроизводительности КАК РегСвОценкаПроизводительности
	|ПО
	|	РегСвОценкаПроизводительности.ИнформационнаяБаза = ИнформационныеБазы.ИнформационнаяБаза
	|	И РегСвОценкаПроизводительности.Период МЕЖДУ ИнформационныеБазы.ДатаНачала И ИнформационныеБазы.ДатаОкончания
	|	И РегСвОценкаПроизводительности.КлючеваяОперация  НЕ В
	|	(ВЫБРАТЬ
	|		Ссылка
	|	ИЗ
	|		КлючевыеОперацииЦентраМониторинга)
	|	{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}
	|СГРУППИРОВАТЬ ПО
	|	ИнформационныеБазы.Конфигурация,
	|	ИнформационныеБазы.ВерсияКонфигурации,
	|	РегСвОценкаПроизводительности.ЦелевоеВремя,
	|	РегСвОценкаПроизводительности.КлючеваяОперация
	|ИНДЕКСИРОВАТЬ ПО
	|	ИнформационныеБазы.Конфигурация,
	|	ИнформационныеБазы.ВерсияКонфигурации,
	|	РегСвОценкаПроизводительности.КлючеваяОперация,
	|	РегСвОценкаПроизводительности.ЦелевоеВремя
	|;
	//Конец выборки количество различных ИБ по КлючеваяОперация_ВерсияКонфигурации
	//============================================================================
	//Начало выборки количество различных ИБ по Конфигурация_КлючеваяОперация
	|ВЫБРАТЬ
	|	ИнформационныеБазы.Конфигурация КАК Конфигурация,
	|	РегСвОценкаПроизводительности.КлючеваяОперация КАК КлючеваяОперация,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИнформационныеБазы.ИнформационнаяБаза) КАК КоличествоИБ
	|ПОМЕСТИТЬ
	|	КонфигурацияКлючевыеОперацииКоличествоИБ
	|ИЗ
	|	ИнформационныеБазы КАК ИнформационныеБазы
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОценкаПроизводительности КАК РегСвОценкаПроизводительности
	|ПО
	|	РегСвОценкаПроизводительности.ИнформационнаяБаза = ИнформационныеБазы.ИнформационнаяБаза
	|	И РегСвОценкаПроизводительности.Период МЕЖДУ ИнформационныеБазы.ДатаНачала И ИнформационныеБазы.ДатаОкончания
	|	И РегСвОценкаПроизводительности.КлючеваяОперация  НЕ В
	|	(ВЫБРАТЬ
	|		Ссылка
	|	ИЗ
	|		КлючевыеОперацииЦентраМониторинга)
	|	{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}
	|СГРУППИРОВАТЬ ПО
	|	ИнформационныеБазы.Конфигурация,
	|	РегСвОценкаПроизводительности.КлючеваяОперация
	|ИНДЕКСИРОВАТЬ ПО
	|	ИнформационныеБазы.Конфигурация,
	|	РегСвОценкаПроизводительности.КлючеваяОперация
	|;
	//Конец выборки количество различных ИБ по Конфигурация_КлючеваяОперация
	//======================================================================
	//Начало выборки количество различных ИБ по Конфигурации
	|ВЫБРАТЬ
	|	ИнформационныеБазы.Конфигурация КАК Конфигурация,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИнформационныеБазы.ИнформационнаяБаза) КАК КоличествоИБ
	|ПОМЕСТИТЬ
	|	КонфигурацияКоличествоИБ
	|ИЗ
	|	ИнформационныеБазы КАК ИнформационныеБазы
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОценкаПроизводительности КАК РегСвОценкаПроизводительности
	|ПО
	|	РегСвОценкаПроизводительности.ИнформационнаяБаза = ИнформационныеБазы.ИнформационнаяБаза
	|	И РегСвОценкаПроизводительности.Период МЕЖДУ ИнформационныеБазы.ДатаНачала И ИнформационныеБазы.ДатаОкончания
	|	И РегСвОценкаПроизводительности.КлючеваяОперация  НЕ В
	|	(ВЫБРАТЬ
	|		Ссылка
	|	ИЗ
	|		КлючевыеОперацииЦентраМониторинга)
	|	{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}
	|СГРУППИРОВАТЬ ПО
	|	ИнформационныеБазы.Конфигурация
	|ИНДЕКСИРОВАТЬ ПО
	|	ИнформационныеБазы.Конфигурация
	|;
	//Конец выборки количество различных ИБ по Конфигурации
	|ВЫБРАТЬ
	|	ИнформационныеБазы.Конфигурация КАК Конфигурация,
	|	ИнформационныеБазы.ВерсияКонфигурации КАК ВерсияКонфигурации,
	|	ИнформационныеБазы.ВерсияЧисло КАК ВерсияЧисло,
	|	РегСвОценкаПроизводительности.КлючеваяОперация КАК КлючеваяОперация,
	|	РегСвОценкаПроизводительности.ЦелевоеВремя КАК ЦелевоеВремя,
	|	КлючевыеОперацииВерсияИБКоличествоИБ.КоличествоИБ КАК КлючевыеОперацииВерсия_КоличествоИБ,
	|	КонфигурацияКлючевыеОперацииКоличествоИБ.КоличествоИБ КАК КонфигурацияКлючевыеОперации_КоличествоИБ,
	|	КонфигурацияКоличествоИБ.КоличествоИБ КАК Конфигурация_КоличествоИБ,
	|   СУММА(РегСвОценкаПроизводительности.N_T) КАК N_T,
	|	СУММА(РегСвОценкаПроизводительности.N_T_4T) КАК N_T_4T,
	|	СУММА(РегСвОценкаПроизводительности.N_4T) КАК N_4T,
	|	СУММА(РегСвОценкаПроизводительности.N_T + РегСвОценкаПроизводительности.N_T_4T + РегСвОценкаПроизводительности.N_4T) КАК ВсегоЗамеров
	|ИЗ
	|	ИнформационныеБазы КАК ИнформационныеБазы
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОценкаПроизводительности КАК РегСвОценкаПроизводительности
	|ПО
	|	РегСвОценкаПроизводительности.ИнформационнаяБаза = ИнформационныеБазы.ИнформационнаяБаза
	|	И РегСвОценкаПроизводительности.Период МЕЖДУ ИнформационныеБазы.ДатаНачала И ИнформационныеБазы.ДатаОкончания
	|	И РегСвОценкаПроизводительности.КлючеваяОперация  НЕ В
	|	(ВЫБРАТЬ
	|		Ссылка
	|	ИЗ
	|		КлючевыеОперацииЦентраМониторинга)
	|	{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}
	| И РегСвОценкаПроизводительности.ЦелевоеВремя <> 0
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	КлючевыеОперацииВерсияИБКоличествоИБ КАК КлючевыеОперацииВерсияИБКоличествоИБ
	|ПО
	|	КлючевыеОперацииВерсияИБКоличествоИБ.Конфигурация = ИнформационныеБазы.Конфигурация
	|	И КлючевыеОперацииВерсияИБКоличествоИБ.ВерсияКонфигурации = ИнформационныеБазы.ВерсияКонфигурации
	|	И КлючевыеОперацииВерсияИБКоличествоИБ.КлючеваяОперация = РегСвОценкаПроизводительности.КлючеваяОперация
	|	И КлючевыеОперацииВерсияИБКоличествоИБ.ЦелевоеВремя = РегСвОценкаПроизводительности.ЦелевоеВремя
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	КонфигурацияКлючевыеОперацииКоличествоИБ КАК КонфигурацияКлючевыеОперацииКоличествоИБ
	|ПО
	|	КонфигурацияКлючевыеОперацииКоличествоИБ.Конфигурация = ИнформационныеБазы.Конфигурация
	|	И КонфигурацияКлючевыеОперацииКоличествоИБ.КлючеваяОперация = РегСвОценкаПроизводительности.КлючеваяОперация
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	КонфигурацияКоличествоИБ КАК КонфигурацияКоличествоИБ
	|ПО
	|	КонфигурацияКоличествоИБ.Конфигурация = ИнформационныеБазы.Конфигурация
	|СГРУППИРОВАТЬ ПО
	|	ИнформационныеБазы.Конфигурация,
	|	ИнформационныеБазы.ВерсияКонфигурации,
	|	ИнформационныеБазы.ВерсияЧисло,
	|	РегСвОценкаПроизводительности.КлючеваяОперация,
	|	РегСвОценкаПроизводительности.ЦелевоеВремя,
	|	КлючевыеОперацииВерсияИБКоличествоИБ.КоличествоИБ,
	|	КонфигурацияКлючевыеОперацииКоличествоИБ.КоличествоИБ,
	|	КонфигурацияКоличествоИБ.КоличествоИБ
	|";
	
	Запрос.УстановитьПараметр("ТаблицаИнформационныеБазы", ТЗн);
	
	Если ЗначениеЗаполнено(СписокКлючевыхОпераций) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}", "И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)");
		Запрос.УстановитьПараметр("СписокКлючевыхОпераций", СписокКлючевыхОпераций);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}", "");
	КонецЕсли;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = Запрос.Выполнить();
	ТЗн = Результат.Выгрузить();
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Конфигурация) КАК КоличествоКонфигураций,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВерсияКонфигурации) КАК КоличествоВерсий
	|ИЗ
	|	ИнформационныеБазы
	|";
	
	//Запрос.Текст = "
	//// Начало выборки максимальной версии конфигурации
	//|ВЫБРАТЬ
	//|	ИнформационныеБазы.Конфигурация КАК Конфигурация,
	//|	МАКСИМУМ(ИнформационныеБазы.ВерсияЧисло) КАК ВерсияЧисло
	//|ПОМЕСТИТЬ
	//|	ИнформационныеБазыМакс	
	//|ИЗ
	//|	ИнформационныеБазы КАК ИнформационныеБазы
	//|СГРУППИРОВАТЬ ПО
	//|	ИнформационныеБазы.Конфигурация
	//|;
	//// Конец выборки максимальной версии конфигурации
	////====================================================================================
	////Начало выборки количество различных ИБ по Конфигурации_Версия
	//|ВЫБРАТЬ
	//|	ИнформационныеБазыМакс.Конфигурация КАК Конфигурация,
	//|	ИнформационныеБазы.ВерсияКонфигурации КАК ВерсияКонфигурации,
	//|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИнформационныеБазы.ИнформационнаяБаза) КАК КоличествоИБ
	//|ПОМЕСТИТЬ
	//|	КонфигурацияВерсияКоличествоИБ
	//|ИЗ
	//|	ИнформационныеБазыМакс КАК ИнформационныеБазыМакс
	//|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	//|	ИнформационныеБазы КАК ИнформационныеБазы
	//|ПО
	//|	ИнформационныеБазы.Конфигурация = ИнформационныеБазыМакс.Конфигурация
	//|	И ИнформационныеБазы.ВерсияЧисло = ИнформационныеБазыМакс.ВерсияЧисло
	//|СГРУППИРОВАТЬ ПО
	//|	ИнформационныеБазыМакс.Конфигурация,
	//|	ИнформационныеБазы.ВерсияКонфигурации
	//|;
	////Конец выборки количество различных ИБ по Конфигурации_Версия
	//|ВЫБРАТЬ
	//|	КонфигурацияВерсияКоличествоИБ.Конфигурация КАК КонфигурацияГрафик,
	//|	КонфигурацияВерсияКоличествоИБ.ВерсияКонфигурации КАК ВерсияКонфигурацииГрафик,
	//|	ИнформационныеБазы.ВерсияЧисло КАК ВерсияЧислоГрафик,
	//|	КонфигурацияВерсияКоличествоИБ.КоличествоИБ КАК КоличествоИБГрафик,
	//|	(СУММА(РегСвОценкаПроизводительности.N_T) + СУММА(РегСвОценкаПроизводительности.N_T_4T)/2)/ 
	//|   (
	//|   	СУММА(РегСвОценкаПроизводительности.N_T)
	//|		+ СУММА(РегСвОценкаПроизводительности.N_T_4T)
	//|		+ СУММА(РегСвОценкаПроизводительности.N_4T)
	//|	) КАК APDEXГрафик
	//|ИЗ
	//|	КонфигурацияВерсияКоличествоИБ КАК КонфигурацияВерсияКоличествоИБ
	//|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	//|	ИнформационныеБазы КАК ИнформационныеБазы
	//|ПО
	//|	ИнформационныеБазы.Конфигурация = КонфигурацияВерсияКоличествоИБ.Конфигурация
	//|	И ИнформационныеБазы.ВерсияКонфигурации = КонфигурацияВерсияКоличествоИБ.ВерсияКонфигурации
	//|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	//|	РегистрСведений.ОценкаПроизводительности КАК РегСвОценкаПроизводительности
	//|ПО
	//|	РегСвОценкаПроизводительности.ИнформационнаяБаза = ИнформационныеБазы.ИнформационнаяБаза
	//|	И РегСвОценкаПроизводительности.Период МЕЖДУ ИнформационныеБазы.ДатаНачала И ИнформационныеБазы.ДатаОкончания
	//|	И РегСвОценкаПроизводительности.КлючеваяОперация  НЕ В
	//|	(ВЫБРАТЬ
	//|		Ссылка
	//|	ИЗ
	//|		КлючевыеОперацииЦентраМониторинга)
	//|	{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}
	////|ЛЕВОЕ СОЕДИНЕНИЕ
	////|	КлючевыеОперацииВерсияИБКоличествоИБ КАК КлючевыеОперацииВерсияИБКоличествоИБ
	////|ПО
	////|	КлючевыеОперацииВерсияИБКоличествоИБ.Конфигурация = ИнформационныеБазы.Конфигурация
	////|	И КлючевыеОперацииВерсияИБКоличествоИБ.ВерсияКонфигурации = ИнформационныеБазы.ВерсияКонфигурации
	////|	И КлючевыеОперацииВерсияИБКоличествоИБ.КлючеваяОперация = РегСвОценкаПроизводительности.КлючеваяОперация
	////|	И КлючевыеОперацииВерсияИБКоличествоИБ.ЦелевоеВремя = РегСвОценкаПроизводительности.ЦелевоеВремя
	////|ЛЕВОЕ СОЕДИНЕНИЕ
	////|	КонфигурацияКлючевыеОперацииКоличествоИБ КАК КонфигурацияКлючевыеОперацииКоличествоИБ
	////|ПО
	////|	КонфигурацияКлючевыеОперацииКоличествоИБ.Конфигурация = ИнформационныеБазы.Конфигурация
	////|	И КонфигурацияКлючевыеОперацииКоличествоИБ.КлючеваяОперация = РегСвОценкаПроизводительности.КлючеваяОперация
	////|ЛЕВОЕ СОЕДИНЕНИЕ
	////|	КонфигурацияКоличествоИБ КАК КонфигурацияКоличествоИБ
	////|ПО
	////|	КонфигурацияКоличествоИБ.Конфигурация = ИнформационныеБазы.Конфигурация
	//|СГРУППИРОВАТЬ ПО
	//|	КонфигурацияВерсияКоличествоИБ.Конфигурация,
	//|	КонфигурацияВерсияКоличествоИБ.ВерсияКонфигурации,
	//|	ИнформационныеБазы.ВерсияЧисло,
	//|	КонфигурацияВерсияКоличествоИБ.КоличествоИБ
	//|УПОРЯДОЧИТЬ ПО
	//|	ИнформационныеБазы.ВерсияЧисло
	//|";
	//
	//Если ЗначениеЗаполнено(СписокКлючевыхОпераций) Тогда
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}", "И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)");
	//	Запрос.УстановитьПараметр("СписокКлючевыхОпераций", СписокКлючевыхОпераций);
	//Иначе
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, "{И РегСвОценкаПроизводительности.КлючеваяОперация В (&СписокКлючевыхОпераций)}", "");
	//КонецЕсли;
	//
	Результат = Запрос.Выполнить();
	ТЗнКонфигурации = Результат.Выгрузить();
		
	Возврат Новый Структура("ТЗнДанные, ТЗнКонфигурации", ТЗн, ТЗнКонфигурации);
КонецФункции

#КонецЕсли

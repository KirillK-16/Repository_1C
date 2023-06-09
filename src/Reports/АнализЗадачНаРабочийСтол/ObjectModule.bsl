#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Результат = Новый Структура;
	
	СтандартнаяОбработка = Ложь; // отключаем стандартный вывод отчета - будем выводить программно 
	
	// Получаем настрокий отчета
	Настройки = КомпоновщикНастроек.ПолучитьНастройки(); // Получаем настройки отчета 
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных; // Создаем данные расшифровки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных; // Создаем компоновщик макета 
	// Инициализируем макет компоновки используя схему компоновки данных 
	// и созданные ранее настройки и данные расшифровки
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, 
							Настройки, ДанныеРасшифровки);
	
	// Скомпонуем результат
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,
		,
		ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(0);
	
	//вывод диаграммы	
	Макет = ПолучитьМакет("МакетДиаграммы");
	ОблДиаграмма = Макет.ПолучитьОбласть("Область_Диаграмма");
	Диаграмма = ОблДиаграмма.Рисунки.D1.Объект;
	Диаграмма.Обновление=Ложь;
	Диаграмма.СерииВСтроках = Ложь;
	Диаграмма.Анимация = АнимацияДиаграммы.НеИспользовать;
	ТаблицаДляДиаграммы = ПолучитьДанныеДляНаборДанныхДляДиаграммы(НачалоДня(ТекущаяДата() - (14 * 86400)), КонецДня(ТекущаяДата()), Истина); 	
	Серия1=Диаграмма.Серии.Добавить("Выполнено");
	Серия2=Диаграмма.Серии.Добавить("Зарегистрировано");
	Для Каждого СтрТЗ из ТаблицаДляДиаграммы Цикл
		Точка=Диаграмма.Точки.Добавить(Формат(СтрТЗ.ДатаДляДиаграммы,"ДФ=dd.MM.yy"));
		Диаграмма.УстановитьЗначение(Точка,Серия1,СтрТЗ.Выполнено);
		Диаграмма.УстановитьЗначение(Точка,Серия2,СтрТЗ.Зарегистрировано);
	КонецЦикла; 
	Диаграмма.Обновление=Истина;
	ЭтотОбъект.РезультатДиаграмма.Очистить();
	ЭтотОбъект.РезультатДиаграмма.Вывести(ОблДиаграмма);
	
	Если ЭтотОбъект.РезультатДиаграмма.Рисунки.Количество() = 1 Тогда
		ЭтотОбъект.РезультатДиаграмма.Рисунки[0].Объект.Обновление = Ложь;
		ЭтотОбъект.РезультатДиаграмма.Рисунки[0].Высота = 60;
		ЭтотОбъект.РезультатДиаграмма.Рисунки[0].Ширина = 100;
		ЭтотОбъект.РезультатДиаграмма.Рисунки[0].Объект.Обновление = Истина;
		
		ЭтотОбъект.РезультатДиаграмма.Рисунки[0].Объект.ОбластьПостроения.ОриентацияМеток = ОриентацияМетокДиаграммы.Вертикально;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьДанныеДляНаборДанныхДляДиаграммы(ДатаНачала, ДатаОкончания, СНакоплением)
	
	МассивДат = Новый ТаблицаЗначений;
	МассивДат.Колонки.Добавить("ДатаДляДиаграммы", Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	МассивДат.Колонки.Добавить("ДатаДляСоединения", Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	
	ДатаВЦикле = ДатаНачала; 
	
	Пока ДатаВЦикле <= ДатаОкончания Цикл  
		СтрокаМассиваДат = МассивДат.Добавить();
		СтрокаМассиваДат.ДатаДляДиаграммы = КонецДня(ДатаВЦикле);
		СтрокаМассиваДат.ДатаДляСоединения = НачалоДня(ДатаВЦикле);
		ДатаВЦикле = ДатаВЦикле + 86400;
	КонецЦикла;
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МассивДат.ДатаДляДиаграммы,
	               |	МассивДат.ДатаДляСоединения КАК ДатаДляСоединения
	               |ПОМЕСТИТЬ МассивДат
	               |ИЗ
	               |	&МассивДат КАК МассивДат
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ДатаДляСоединения
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(1) КАК Количество,
	               |	МассивДат.ДатаДляСоединения КАК ДатаДляДиаграммы
	               |ПОМЕСТИТЬ КоличествоОткрытыхЗадач
	               |ИЗ
	               |	Задача.ЗадачаОтветственному КАК ЗадачаОтветственному
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МассивДат КАК МассивДат
	               |		ПО ЗадачаОтветственному.Дата <= МассивДат.ДатаДляДиаграммы
	               |			И (&СтрокаСоединения)
	               |ГДЕ
	               |	ЗадачаОтветственному.Выполнена = ЛОЖЬ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	МассивДат.ДатаДляДиаграммы,
	               |	МассивДат.ДатаДляСоединения
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ДатаДляДиаграммы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СУММА(1) КАК Количество,
	               |	МассивДат.ДатаДляСоединения КАК ДатаДляДиаграммы
	               |ПОМЕСТИТЬ КоличествоВыполненныхЗадач
	               |ИЗ
	               |	Задача.ЗадачаОтветственному КАК ЗадачаОтветственному
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МассивДат КАК МассивДат
	               |		ПО ЗадачаОтветственному.Дата <= МассивДат.ДатаДляДиаграммы
	               |			И (&СтрокаСоединения)
	               |ГДЕ
	               |	ЗадачаОтветственному.Выполнена = ИСТИНА
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	МассивДат.ДатаДляДиаграммы,
	               |	МассивДат.ДатаДляСоединения
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ДатаДляДиаграммы
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МассивДат.ДатаДляДиаграммы,
	               |	ЕСТЬNULL(КоличествоВыполненныхЗадач.Количество, 0) КАК Выполнено,
	               |	ЕСТЬNULL(КоличествоОткрытыхЗадач.Количество, 0) КАК Зарегистрировано
	               |ИЗ
	               |	МассивДат КАК МассивДат
	               |		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоОткрытыхЗадач КАК КоличествоОткрытыхЗадач
	               |		ПО МассивДат.ДатаДляСоединения = КоличествоОткрытыхЗадач.ДатаДляДиаграммы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоВыполненныхЗадач КАК КоличествоВыполненныхЗадач
	               |		ПО МассивДат.ДатаДляСоединения = КоличествоВыполненныхЗадач.ДатаДляДиаграммы";
				   
	Если СНакоплением Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&СтрокаСоединения", "ЗадачаОтветственному.Дата >= &ДатаНачала");
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&СтрокаСоединения", "ЗадачаОтветственному.Дата >= МассивДат.ДатаДляСоединения");
	КонецЕсли;				
	
	Запрос.УстановитьПараметр("МассивДат", МассивДат);				   
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	
	Возврат Запрос.Выполнить().Выгрузить();
				   
КонецФункции

#КонецЕсли

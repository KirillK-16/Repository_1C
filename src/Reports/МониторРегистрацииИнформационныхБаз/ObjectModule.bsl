#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	// Отключаем стандартный вывод отчета - будем выводить программно 
	СтандартнаяОбработка = Ложь;
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();						// Получаем настройки отчета
	ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;  // Получаем пользовательские настройки
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;				// Создаем данные расшифровки 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;				// Создаем компоновщик макета 
	
	// Инициализируем макет компоновки используя схему компоновки данных 
	СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных; 
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки);
	
	ДокументРезультат.Очистить();
	
	// Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если ДокументРезультат.Рисунки.Количество() > 0 Тогда
		ДокументРезультат.Рисунки[0].Ширина = 320;
		//ДокументРезультат.Рисунки[0].Высота = 150;
		
		Диаграмма = ДокументРезультат.Рисунки[0].Объект;
		Диаграмма.Анимация = АнимацияДиаграммы.НеИспользовать;
		
		Диаграмма.ОбластьПостроения.Верх = 0;
		Диаграмма.ОбластьПостроения.Низ = 0.8;
		Диаграмма.ОбластьПостроения.Лево = 0;
		Диаграмма.ОбластьПостроения.Право = 1;
		
		Диаграмма.ОбластьЛегенды.Верх = 0.81;
		Диаграмма.ОбластьЛегенды.Низ = 1;
		Диаграмма.ОбластьЛегенды.Лево = 0;
		Диаграмма.ОбластьЛегенды.Право = 1;

		Диаграмма.ОбластьПостроения.ОриентацияМеток = ОриентацияМетокДиаграммы.Вертикально;
		
		Для Каждого ТекСерия Из Диаграмма.Серии Цикл
			ТекСерия.Маркер = ТипМаркераДиаграммы.Нет;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
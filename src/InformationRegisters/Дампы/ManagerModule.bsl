#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция РезультатЗапросаВМассив(Результат)
	РезультатМассив = Новый Массив;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеСтроки = Новый Структура;
		
		Для Каждого ТекКолонка Из Результат.Колонки Цикл
			ДанныеСтроки.Вставить(ТекКолонка.Имя, Выборка[ТекКолонка.Имя]);
		КонецЦикла;
		
		РезультатМассив.Добавить(ДанныеСтроки);
	КонецЦикла;	
	
	Возврат РезультатМассив;
КонецФункции

Функция ВыбратьПоСостояниюОбработки(СостояниеОбработки) Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.Дампы КАК Дампы
	|ГДЕ
	|	Дампы.СостояниеОбработкиДампа = &СостояниеОбработки
	|УПОРЯДОЧИТЬ ПО
	|	Дампы.Период
	|";
	
	Запрос.УстановитьПараметр("СостояниеОбработки", СостояниеОбработки);	
	Результат = Запрос.Выполнить();
	Данные = РезультатЗапросаВМассив(Результат);
	
	Возврат Данные;
КонецФункции

Функция ВыбратьПоСостояниямОбработки(СостоянияОбработки) Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.Дампы КАК Дампы
	|ГДЕ
	|	Дампы.СостояниеОбработкиДампа В (&СостоянияОбработки)
	|УПОРЯДОЧИТЬ ПО
	|	Дампы.Период
	|";
	
	Запрос.УстановитьПараметр("СостоянияОбработки", СостоянияОбработки);	
	Результат = Запрос.Выполнить();
	Данные = РезультатЗапросаВМассив(Результат);
	
	Возврат Данные;
КонецФункции

Функция ИзменитьЗапись(ДанныеЗаписиРегистра) Экспорт
	НаборЗаписей = РегистрыСведений.Дампы.СоздатьНаборЗаписей();
	
	Регистр = Метаданные.РегистрыСведений.Дампы;
	
	Если Регистр.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый И Регистр.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		НаборЗаписей["Отбор"]["Период"].Установить(ДанныеЗаписиРегистра["Период"]);
	КонецЕсли;
	
	Для Каждого ТекИзмерение Из Метаданные.РегистрыСведений.Дампы.Измерения Цикл
		НаборЗаписей["Отбор"][ТекИзмерение.Имя].Установить(ДанныеЗаписиРегистра[ТекИзмерение.Имя]);
	КонецЦикла;
	
	НовЗапись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(НовЗапись, ДанныеЗаписиРегистра);	
	
	Попытка
		НаборЗаписей.Записать(Истина);
		Справочники.ВариантыДампов.ПриИзмененииЗаписиДампа(ДанныеЗаписиРегистра.ВариантДампа, ДанныеЗаписиРегистра.СостояниеОбработкиДампа);
	Исключение
		Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			"Функция ЗаписатьРазмерФайла(...)",
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.Дампы,
			,
			Комментарий);
	КонецПопытки;
КонецФункции

Процедура ПереименоватьДамп(ДанныеЗаписиРегистра, НовоеИмяДампа) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.Дампы.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписиРегистра);
	МенеджерЗаписи.Прочитать();
	
	ФайлДампа = Новый Файл(НовоеИмяДампа);
	
	Попытка
		ПереместитьФайл(ДанныеЗаписиРегистра.ПолноеИмя, НовоеИмяДампа);
	Исключение
		Инфо = ИнформацияОбОшибке();
		Комментарий =
			"Описание = '" +Инфо.Описание + "', " +
			"ИмяМодуля = '" + Инфо.ИмяМодуля + "', " +
			"НомерСтроки = '" + Инфо.НомерСтроки + "', " +
			"ИсходнаяСтрока = '" + Инфо.ИсходнаяСтрока + "'.";
		ЗаписьЖурналаРегистрации("Ошибка переименования файла " + ФайлДампа.ПолноеИмя, УровеньЖурналаРегистрации.Информация,,,Комментарий);
		Возврат
	КонецПопытки;
	
	МенеджерЗаписи.ИмяФайлаДампа = ФайлДампа.Имя;
	МенеджерЗаписи.ПолноеИмя = ФайлДампа.ПолноеИмя;
	МенеджерЗаписи.ИмяБезРасширения = ФайлДампа.ИмяБезРасширения;
	
	МенеджерЗаписи.Записать(Истина);
	
	ЗаполнитьЗначенияСвойств(ДанныеЗаписиРегистра, МенеджерЗаписи);
	
КонецПроцедуры

#КонецЕсли
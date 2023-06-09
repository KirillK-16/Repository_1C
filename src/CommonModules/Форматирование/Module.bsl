// Преобразовать объект типа ИнформацияОбОшибке в строку.
//
// Параметры:
//  Ошибка - ИнформацияОбОшибке, структурированное описание ошибки;
//         - Строка, текстовое описание ошибки.
//  НомерПричины - Число, номер причины ошибки (служебный параметр).
//
// Возвращаемое значение:
//  Строка - Строковое предстваление ошибки.
//
Функция ИнформациюОбОшибкеВСтроку(Ошибка, НомерПричины = 0) Экспорт
	
	ТипОшибки = ТипЗнч(Ошибка);
	ТипИнформацияОбОшибке = Тип("ИнформацияОбОшибке");
	ТипСтруктура = Тип("Структура");
	
	Если ТипОшибки = ТипИнформацияОбОшибке Или ТипОшибки = ТипСтруктура Тогда
		Текст = Ошибка.Описание;
		
		Если Не ПустаяСтрока(Ошибка.ИмяМодуля) Тогда
			Текст = Текст + "
				|
				|{" + Ошибка.ИмяМодуля + "(" + Ошибка.НомерСтроки + ")}";
		КонецЕсли;
		
		Если Не ПустаяСтрока(Ошибка.ИсходнаяСтрока) Тогда
			Текст = Текст + ":
				|" + Ошибка.ИсходнаяСтрока;
		КонецЕсли;
		
		Если Ошибка.Причина <> Неопределено Тогда
			Причина = НСтр("ru = 'ПРИЧИНА № '");
			НомерПричины = НомерПричины + 1;
			Текст = Текст + "
				|
				|" + Причина + НомерПричины + "
				|" + ИнформациюОбОшибкеВСтроку(Ошибка.Причина, НомерПричины);
		КонецЕсли;
		
		Возврат Текст;
	ИначеЕсли ТипОшибки = Тип("Строка") Тогда
		Возврат Ошибка;
	Иначе
		Возврат Строка(Ошибка);
	КонецЕсли;
	
КонецФункции // ИнформациюОбОшибкеВСтроку()

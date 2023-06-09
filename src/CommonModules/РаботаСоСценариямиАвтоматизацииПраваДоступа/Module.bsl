#Область ПрограммныйИнтерфейс
// Выполняет проверку наличия полного доступа к функционалу 1С:Центр администрирования.
//
// Параметры:
//
Функция ПроверитьНаличиеПолногоДоступаКФункционалуАвтоматизации() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Результат = РольДоступна(Метаданные.Роли.АвтоматизацияПолныеПрава);
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
КонецФункции
 
Процедура УстановитьОтборПоДоступнымЭлементамНаКонтурыАвтоматизации(Список) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ПроверитьНаличиеПолногоДоступаКФункционалуАвтоматизации() Тогда
		ОграниченияКонтура = РаботаСоСценариямиАвтоматизацииПовторноеИспользование.ПолучитьСписокОграниченийДляТекущегоПользователя();
		Если ОграниченияКонтура.Количество() > 0 Тогда
			УстановитьОтборПоДоступнымЭлементамНаСписокФормы(Список, ОграниченияКонтура)
		КонецЕсли;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура УстановитьОтборПоДоступнымЭлементамНаСписокФормы(СписокФормы, ОграниченияКонтура) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	МассивОграничений = Новый Массив;
	МассивОграничений.Добавить("Ссылка");
	СписокФормы.УстановитьОграниченияИспользованияВОтборе(МассивОграничений);
	
	// почистим отбор (если установлен ранее, а сейчас его обновляем)
	СписокФормы.Отбор.Элементы.Очистить();
	
    ГруппаОтбора = СписокФормы.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
    ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
    
	Эл = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Эл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	Эл.ПравоеЗначение = ОграниченияКонтура;
	Эл.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры	

Функция ПроверитьПравоДоступа(Право, ОбъектМетаданных, Пользователь = Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Результат = ПравоДоступа(Право, ОбъектМетаданных);
	Иначе
		Результат = ПравоДоступа(Право, ОбъектМетаданных, Пользователь);
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Результат;
КонецФункции

Функция ПолучитьРолиПользователя(ИмяПользователяИБ) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	ТаблицаРезультат.Колонки.Добавить("Установлена");
	ТаблицаРезультат.Колонки.Добавить("ИмяРоли");
	ТаблицаРезультат.Колонки.Добавить("СинонимРоли");
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователяИБ);
	Если ПользовательИБ <> Неопределено Тогда
		РолиКонфигурации = Метаданные.Роли;
		Для Каждого Роль Из РолиКонфигурации Цикл
			ДобавитьРольВТаблицу(ТаблицаРезультат, Роль, ПользовательИБ);
		КонецЦикла;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТаблицаРезультат;
КонецФункции

Процедура ДобавитьРольВТаблицу(Таблица, МетаданныеРоли, ПользовательИБ)
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.ИмяРоли = МетаданныеРоли.Имя;
	НоваяСтрока.СинонимРоли = МетаданныеРоли.Синоним;
	Если ПользовательИБ.Роли.Содержит(МетаданныеРоли) Тогда
		НоваяСтрока.Установлена = Истина;
	КонецЕсли;	
КонецПроцедуры	

Процедура ЗаписатьРолиПользователя(ИмяПользователяИБ, ТаблицаРолей) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователяИБ);
	Если ПользовательИБ <> Неопределено Тогда
		Изменен = Ложь;
		Для Каждого Строка Из ТаблицаРолей Цикл
			Если Не Строка.Установлена И ПользовательИБ.Роли.Содержит(Метаданные.Роли[Строка.ИмяРоли]) Тогда
				ПользовательИБ.Роли.Удалить(Метаданные.Роли[Строка.ИмяРоли]);
				Изменен = Истина;
			ИначеЕсли Строка.Установлена И Не ПользовательИБ.Роли.Содержит(Метаданные.Роли[Строка.ИмяРоли]) Тогда
				ПользовательИБ.Роли.Добавить(Метаданные.Роли[Строка.ИмяРоли]);
				Изменен = Истина;	
			КонецЕсли;	
		КонецЦикла;
		Если Изменен Тогда
			ПользовательИБ.Записать();
		КонецЕсли;	
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры	

#КонецОбласти
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция СоздатьЭлементПоХешу(Хеш, ПолныйСтек) Экспорт
		
	//Проверка на недопустимые символы
	ПроверитьНаличиеНедопустимыхСимволов(Хеш, "Хеш");
	ПроверитьНаличиеНедопустимыхСимволов(ПолныйСтек, "ПолныйСтек");
		
	Результат = РезультатЗапросаПоХешу(Хеш);
	Если Результат.Пустой() Тогда
		Попытка
			БлокировкаДанных = Новый БлокировкаДанных;
			ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ОбъектыБлокировок");
			ЭлементБлокировки.УстановитьЗначение("Объект", "Справочник.СтекиОшибокЦентрМониторинга." + Хеш);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			БлокировкаДанных.Заблокировать();
		Исключение
			ВызватьИсключение "Центр мониторинга. Ожидаемая управляемая блокировка при создании элемента справочника 'СтекиОшибокЦентрМониторинга'";
		КонецПопытки;
		
		Результат = РезультатЗапросаПоХешу(Хеш);
		Если Результат.Пустой() Тогда
			НовыйЭлемент = Справочники.СтекиОшибокЦентрМониторинга.СоздатьЭлемент();
			НовыйЭлемент.Наименование = Лев(ПолныйСтек, 150);
			НовыйЭлемент.ПолныйСтек = ПолныйСтек;
			НовыйЭлемент.ХешСтека = Хеш;
			НовыйЭлемент.Записать();
			
			РезультатВыполнения = НовыйЭлемент.Ссылка;
		Иначе
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			РезультатВыполнения = Выборка.Ссылка;
		КонецЕсли;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		РезультатВыполнения = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

Функция РезультатЗапросаПоХешу(ИмяХеш)
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Справочник.СтекиОшибокЦентрМониторинга
	|ГДЕ
	|	ХешСтека = &ХешСтека
	|";
	Запрос.УстановитьПараметр("ХешСтека", ИмяХеш);
	Результат = Запрос.Выполнить();
	
	Возврат Результат;
КонецФункции

Процедура ПроверитьНаличиеНедопустимыхСимволов(Значение, Имя)
	ПозицияНедопустимогоСимвола = НайтиНедопустимыеСимволыXML(Имя);
	Если ПозицияНедопустимогоСимвола > 0 Тогда
		ВызватьИсключение СтрШаблон("Обнаружен недопустимый символ XML, позиция: %1, реквизит: %2", ПозицияНедопустимогоСимвола, Имя);
	КонецЕсли;
КонецПроцедуры

#КонецЕсли
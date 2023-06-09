#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьСсылкуПоНаименованию(ИмяПользователя, СоздатьНового = Ложь) Экспорт
	Ссылка = ПолучитьСсылкуПоНаименованиюСлужебный(ИмяПользователя);
	
	Если Ссылка = Неопределено И СоздатьНового Тогда
		НачатьТранзакцию();
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировки = БлокировкаДанных.Добавить("Справочник.ПользователиЗамерПроизводительности");
		ЭлементБлокировки.УстановитьЗначение("Наименование", ИмяПользователя);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		Попытка
			БлокировкаДанных.Заблокировать();
			
			Ссылка = ПолучитьСсылкуПоНаименованиюСлужебный(ИмяПользователя);
			Если Ссылка = Неопределено Тогда
				Ссылка = СоздатьПоНаименованию(ИмяПользователя);	
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Ссылка;
КонецФункции

Функция СоздатьПоНаименованию(ИмяПользователя)
	НовыйЭлемент = Справочники.ПользователиЗамерПроизводительности.СоздатьЭлемент();
	НовыйЭлемент.Наименование = ИмяПользователя;
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент.Ссылка;
КонецФункции

Функция ПолучитьСсылкуПоНаименованиюСлужебный(ИмяПользователя)
	Ссылка = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1 
	|	ПользователиЗамерПроизводительности.Ссылка КАК Пользователь
	|ИЗ
	|	Справочник.ПользователиЗамерПроизводительности КАК ПользователиЗамерПроизводительности
	|ГДЕ
	|	ПользователиЗамерПроизводительности.Наименование = &Наименование
	|";
	Запрос.УстановитьПараметр("Наименование", ИмяПользователя);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Ссылка = Выборка.Пользователь;
	КонецЕсли;
	
	Возврат Ссылка;		
КонецФункции

#КонецЕсли

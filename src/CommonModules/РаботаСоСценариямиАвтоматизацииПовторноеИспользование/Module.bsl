Функция ПолучитьСписокОграниченийДляТекущегоПользователя() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ОграниченияДоступаККонтурамАвтоматизацииДоступныеКонтурыАвтоматизации.Контур КАК Контур
	                      |ИЗ
	                      |	Справочник.ОграниченияДоступаККонтурамАдминистрирования.ДоступныеКонтуры КАК ОграниченияДоступаККонтурамАвтоматизацииДоступныеКонтурыАвтоматизации
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОграниченияДоступаККонтурамАдминистрирования.ПользователиИБ КАК ОграниченияДоступаККонтурамАвтоматизацииПользователиИБ
	                      |		ПО ОграниченияДоступаККонтурамАвтоматизацииДоступныеКонтурыАвтоматизации.Ссылка = ОграниченияДоступаККонтурамАвтоматизацииПользователиИБ.Ссылка
	                      |ГДЕ
	                      |	ОграниченияДоступаККонтурамАвтоматизацииПользователиИБ.Имя = &Имя
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Контур");
	Запрос.УстановитьПараметр("Имя", ТекущийПользователь.Имя);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Новый ФиксированныйМассив(Результат.ВыгрузитьКолонку("Контур"));
КонецФункции	
